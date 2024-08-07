// This contract is a translation of
// https://github.com/Pi-Squared-Inc/pi2-examples/blob/94e77f575041c10df678bac0f693815ec19e126b/solidity/src/lending/LendingPool.sol
//
// Changes:
// *  Does not emit events
// *  Does not issue specific error objects, (e.g. TransferFailed), it just
//    calls `require!` with various (string) explanations.
#![no_std]

#[allow(unused_imports)]
use multiversx_sc::imports::*;

pub const USD_PER_TOKEN: u64 = 10_u64;
pub const INTEREST_RATE: u64 = 10_000_u64;
pub const RESERVE_RATIO: u64 = 10_000_u64;
pub const BPS: u64 = 100_000_u64;

pub const LIQUIDATION_THRESHOLD: u64 = 80_000_u64;
pub const LIQUIDATION_REWARD: u64 = 1_000_u64;
pub const MIN_HEALTH_FACTOR: u64 = 1_000_000_000_000_000_000_u64;
pub const PRECISION: u64 = 1_000_000_u64;
pub const BLOCKS_PER_YEAR: u64 = 365_u64 * 24_u64 * 60_u64 * 10_u64;

#[multiversx_sc::contract]
pub trait Lending {
    #[init]
    fn init(&self) {
    }

    #[upgrade]
    fn upgrade(&self) {}

    #[view(getTokens)]
    #[storage_mapper("tokens")]
    fn tokens(&self) -> UnorderedSetMapper<TokenIdentifier>;

    #[view(getTokenAmount)]
    #[storage_mapper("token_amount")]
    fn token_amount(&self, token: &TokenIdentifier) -> SingleValueMapper<BigUint>;

    #[view(getTokenBorrowed)]
    #[storage_mapper("token_borrowed")]
    fn token_borrowed(&self, token: &TokenIdentifier) -> SingleValueMapper<BigUint>;

    #[view(getTokenShares)]
    #[storage_mapper("token_shares")]
    fn token_shares(&self, token: &TokenIdentifier) -> SingleValueMapper<BigUint>;

    #[view(getTokenBorrowedShares)]
    #[storage_mapper("token_borrowed_shares")]
    fn token_borrowed_shares(&self, token: &TokenIdentifier) -> SingleValueMapper<BigUint>;

    #[view(getUserShares)]
    #[storage_mapper("user_shares")]
    fn user_shares(&self, user: &ManagedAddress, token: &TokenIdentifier) -> SingleValueMapper<BigUint>;

    #[view(getUserBorrowedShares)]
    #[storage_mapper("user_borrowed_shares")]
    fn user_borrowed_shares(&self, user: &ManagedAddress, token: &TokenIdentifier) -> SingleValueMapper<BigUint>;

    #[view(getLastTimestamp)]
    #[storage_mapper("last_timestamp")]
    fn last_timestamp(&self, token: &TokenIdentifier) -> SingleValueMapper<u64>;


    #[endpoint(whitelist)]
    fn whitelist(&self, token: TokenIdentifier) {
        self.tokens().insert(token);
    }

    #[payable("*")]
    #[endpoint(supply)]
    fn supply(&self) {
        let caller =
            self.blockchain().get_caller();
        let (token, amount) =
            self.call_value().single_fungible_esdt();

        require!(amount > BigUint::zero(), "Zero amount!");
        require!(self.tokens().contains(&token), "Token not whitelisted.");

        self.accrue_interest(&token);

        let token_amount = self.token_amount(&token).get();
        let token_shares = self.token_shares(&token).get();

        let shares = 
            self.to_shares(
                &amount,
                &token_amount,
                &token_shares,
                false
            );

        self.token_amount(&token).set(token_amount + amount);
        self.token_shares(&token).set(token_shares + &shares);

        let user_shares = self.user_shares(&caller, &token).get();

        self.user_shares(&caller, &token).set(user_shares + shares);
    }


    #[endpoint(borrow)]
    fn borrow(&self, token: &TokenIdentifier, amount: &BigUint) {
        require!(self.tokens().contains(&token), "Token not whitelisted");
        require!(self.vault_above_reserve_ratio(token, amount), "Not enough tokens");

        self.accrue_interest(token);

        let token_borrowed = self.token_borrowed(&token).get();
        let token_borrowed_shares = self.token_borrowed_shares(&token).get();

        let shares = 
            self.to_shares(
                &amount,
                &token_borrowed,
                &token_borrowed_shares,
                false
            );

        self.token_borrowed(&token).set(token_borrowed + amount);
        self.token_borrowed_shares(&token).set(&token_borrowed_shares + &shares);

        let caller = self.blockchain().get_caller();
        let user_borrowed_shares = self.user_borrowed_shares(&caller, &token).get();

        self.user_borrowed_shares(&caller, &token).set(user_borrowed_shares + shares);

        self.send().direct_esdt(&caller, token, 0, amount);

        require!(self.health_factor(&caller) >= MIN_HEALTH_FACTOR, "Not healthy enough.");
    }


    #[payable("*")]
    #[endpoint(repay)]
    fn repay(&self) {
      let (token, amount) = self.call_value().single_fungible_esdt();
      require!(self.tokens().contains(&token), "Token not whitelisted");

        self.accrue_interest(&token);
        let caller = self.blockchain().get_caller();
        let token_borrowed = self.token_borrowed(&token).get();
        let token_borrowed_shares = self.token_borrowed_shares(&token).get();
        let user_borrow_shares = self.user_borrowed_shares(&caller, &token).get();
        let shares_for_amount =
            self.to_shares(
                &amount,
                &token_borrowed,
                &token_borrowed_shares,
                true
            );

        require!(shares_for_amount <= user_borrow_shares, "Too many shares");

        self.token_borrowed(&token).set(token_borrowed - amount);
        self.token_borrowed_shares(&token).set(token_borrowed_shares - &shares_for_amount);
        self.user_borrowed_shares(&caller, &token).set(user_borrow_shares - &shares_for_amount);
    }


    #[endpoint(redeem)]
    fn redeem(&self, token: &TokenIdentifier, shares: &BigUint) {
        require!(self.tokens().contains(&token), "Token not whitelisted");

        self.accrue_interest(token);

        require!(&BigUint::zero() < shares, "Zero shares");

        let caller = self.blockchain().get_caller();
        let user_shares = self.user_shares(&caller, token).get();

        require!(shares <= &user_shares, "Too many shares");

        let token_amount = self.token_amount(token).get();
        let token_shares = self.token_shares(token).get();

        let amount =
            self.to_amount(
                &shares,
                &token_amount,
                &token_shares,
                false
            );

        require!(BigUint::zero() < amount, "Amount too low");
        require!(amount <= self.balance(token), "Not enough tokens");

        self.token_amount(&token).set(token_amount - &amount);
        self.token_shares(&token).set(token_shares - shares);
        self.user_shares(&caller, &token).set(user_shares - shares);

        require!(self.health_factor(&caller) >= MIN_HEALTH_FACTOR, "Too ill");

        self.send().direct_esdt(&caller, token, 0, &amount);
    }


    #[payable("*")]
    #[endpoint(liquidate)]
    fn liquidate(
        &self,
        borrower: &ManagedAddress,
        collateral_token: &TokenIdentifier,
    ) {
        let caller = self.blockchain().get_caller();
        let (borrow_token, borrow_liquidation_amount) =
            self.call_value().single_fungible_esdt();

        self.accrue_interest(collateral_token);
        self.accrue_interest(&borrow_token);

        require!(&caller != borrower, "Cannot self-liquidate");
        require!(self.tokens().contains(&borrow_token), "Borrow token not whitelisted");
        require!(self.tokens().contains(collateral_token), "Collateral token not whitelisted");

        require!(self.health_factor(&borrower) < MIN_HEALTH_FACTOR, "Too healthy");

        let collateral_shares =
            self.user_shares(borrower, collateral_token).get();
        let borrow_shares =
            self.user_borrowed_shares(borrower, &borrow_token).get();
        require!(collateral_shares > BigUint::zero(), "No collateral shares");
        require!(borrow_shares > BigUint::zero(), "No borrow shares");
        require!(borrow_liquidation_amount > BigUint::zero(), "No amount received");

        let token_borrowed = self.token_borrowed(&borrow_token).get();
        let token_borrowed_shares = self.token_borrowed_shares(&borrow_token).get();

        let borrow_amount =
            self.to_amount(
                &borrow_shares,
                &token_borrowed,
                &token_borrowed_shares,
                true
            );

        require!(borrow_liquidation_amount <= borrow_amount, "Liquidating too much.");

        let token_amount = self.token_amount(collateral_token).get();
        let token_shares = self.token_shares(collateral_token).get();

        let collateral_amount =
            self.to_amount(
                &collateral_shares,
                &token_amount,
                &token_shares,
                false
            );
        require!(collateral_amount > 0, "Collateral amount too low");

        let collateral_to_liquidate =
            self.to_usd(&borrow_token, &borrow_liquidation_amount)
            / self.to_usd(&collateral_token, &BigUint::from(1_u64));
        let liquidation_reward =
            (&collateral_to_liquidate * &BigUint::from(LIQUIDATION_REWARD)) / BigUint::from(BPS);
        let total_collateral_to_liquidate = collateral_to_liquidate + liquidation_reward;

        require!(total_collateral_to_liquidate <= collateral_amount, "Not enough collateral");

        let borrow_liquidation_shares =
            self.to_shares(
                &borrow_liquidation_amount,
                &token_borrowed,
                &token_borrowed_shares,
                false
            );

        self.token_borrowed(&borrow_token).set(token_borrowed - &borrow_liquidation_amount);
        self.token_borrowed_shares(&borrow_token).set(token_borrowed_shares - &borrow_liquidation_shares);
        self.user_borrowed_shares(&borrower, &borrow_token).set(borrow_shares - &borrow_liquidation_shares);

        let total_collateral_liquidation_shares =
            self.to_shares(
                &total_collateral_to_liquidate,
                &token_amount,
                &token_shares,
                false
            );

        require!(total_collateral_to_liquidate < self.token_amount(&collateral_token).get(), "Cannot repay collateral");
        self.token_amount(&collateral_token).set(token_amount - &total_collateral_to_liquidate);
        self.token_shares(&collateral_token).set(token_shares - &total_collateral_liquidation_shares);
        self.user_shares(&borrower, &collateral_token).set(collateral_shares - &total_collateral_liquidation_shares);

        self.send().direct_esdt(&caller, collateral_token, 0, &total_collateral_to_liquidate);
    }


    fn health_factor(&self, user: &ManagedAddress) -> BigUint {
        let total_token_collateral =
            self.get_user_total_token_collateral(user);
        let total_borrow_value =
            self.get_user_total_borrow_value(user);

        if total_borrow_value == 0 {
            return BigUint::from(BigUint::from(100_u64) * BigUint::from(MIN_HEALTH_FACTOR));
        };
        let collateral_value_with_threshold =
            (total_token_collateral * LIQUIDATION_THRESHOLD) / BPS;
        (collateral_value_with_threshold * MIN_HEALTH_FACTOR) / total_borrow_value
    }


    fn vault_above_reserve_ratio(
        &self,
        token: &TokenIdentifier,
        borrowed_amount: &BigUint
    ) -> bool {
        let total_amount = self.token_amount(token).get();
        let min_reserve = (&total_amount * RESERVE_RATIO) / BPS;
        let balance = self.balance(token);
        &total_amount > &BigUint::zero() &&
            balance >= min_reserve + borrowed_amount
    }


    fn balance(&self, token: &TokenIdentifier) -> BigUint {
        self.blockchain().get_sc_balance(&EgldOrEsdtTokenIdentifier::esdt(token.clone()), 0)
    }


    fn get_user_total_borrow_value(&self, user: &ManagedAddress) -> BigUint {
        let mut total_usd = BigUint::zero();
        for token in self.tokens().into_iter() {
            let shares = self.user_borrowed_shares(user, &token).get();
            let amount =
                self.to_amount(
                    &shares,
                    &self.token_borrowed(&token).get(),
                    &self.token_borrowed_shares(&token).get(),
                    false
                );
            total_usd += self.to_usd(&token, &amount);
        };
        total_usd
    }


    fn get_user_total_token_collateral(&self, user: &ManagedAddress) -> BigUint {
        let mut total_usd = BigUint::zero();
        for token in self.tokens().into_iter() {
            let shares = self.user_shares(user, &token).get();
            let amount =
                self.to_amount(
                    &shares,
                    &self.token_amount(&token).get(),
                    &self.token_shares(&token).get(),
                    false
                );
            total_usd += self.to_usd(&token, &amount);
        };
        total_usd
    }


    fn accrue_interest(&self, token: &TokenIdentifier) {
        let last_timestamp = self.last_timestamp(token).get();
        let current_timestamp = self.blockchain().get_block_timestamp();
        require!(last_timestamp <= current_timestamp, "Broken timestamps.");
        if last_timestamp == current_timestamp {
            return;
        };

        let delta_time = current_timestamp - last_timestamp;

        let borrowed_start = self.token_borrowed(token).get();

        // Calculate interest accrued
        let interest_earned =
            (BigUint::from(delta_time) *
                &borrowed_start *
                INTEREST_RATE) /
            (BPS * BLOCKS_PER_YEAR);

        self.token_borrowed(&token).set(borrowed_start + &interest_earned);
        self.token_amount(&token).set(self.token_amount(&token).get() + &interest_earned);
    }

    fn to_usd(&self, _token: &TokenIdentifier, amount: &BigUint) -> BigUint {
        amount * &BigUint::from(USD_PER_TOKEN)
    }

    fn to_shares(&self, amount: &BigUint, total_amount: &BigUint, total_shares: &BigUint, round_up: bool) -> BigUint {
        if total_amount == &BigUint::zero() {
            amount.clone()
        } else {
            self.div_round(&(amount * total_shares), &total_amount, round_up)
        }
    }

    fn to_amount(&self, shares: &BigUint, total_amount: &BigUint, total_shares: &BigUint, round_up: bool) -> BigUint {
        if total_shares == &BigUint::zero() {
            shares.clone()
        } else {
            self.div_round(&(shares * total_amount), &total_shares, round_up)
        }
    }

    fn div_round(&self, a: &BigUint, b: &BigUint, round_up: bool) -> BigUint {
        if round_up {
            (a + b - BigUint::from(1_u64)) / b
        } else {
            a / b
        }
    }

}

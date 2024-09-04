// This contract is a translation of
// https://github.com/Pi-Squared-Inc/pi2-examples/blob/06402f45f37887006544c8be2c1c4d2aa6fdea7a/solidity/src/staking/LiquidStaking.sol

#![no_std]

#[allow(unused_imports)]
use multiversx_sc::imports::*;

pub const YEARLY_INTEREST: u64 = 7_000;
pub const BPS: u64 = 100_000; 
pub const SECONDS_IN_DAY: u64 = 24 * 60 * 60;
pub const SECONDS_IN_YEAR: u64 = 365_u64 * SECONDS_IN_DAY;

#[multiversx_sc::contract]
pub trait Staking {
    #[view(getStakingToken)]
    #[storage_mapper("staking_token")]
    fn staking_token(&self) -> SingleValueMapper<TokenIdentifier>;

    #[view(getRewardToken)]
    #[storage_mapper("reward_token")]
    fn reward_token(&self) -> SingleValueMapper<TokenIdentifier>;

    #[view(getStakedBalances)]
    #[storage_mapper("staked_balances")]
    fn staked_balances(&self, account: &ManagedAddress) -> SingleValueMapper<BigUint>;

    #[view(getStakedTimestamps)]
    #[storage_mapper("staked_timestamps")]
    fn staked_timestamps(&self, account: &ManagedAddress) -> SingleValueMapper<u64>;

    #[view(getStakingDuration)]
    #[storage_mapper("staking_duration")]
    fn staking_duration(&self) -> SingleValueMapper<u64>;

    #[init]
    fn init(&self, staking_token: &TokenIdentifier, reward_token: &TokenIdentifier) {
        self.staking_duration().set(30 * SECONDS_IN_DAY);
        self.staking_token().set_if_empty(staking_token);
        self.reward_token().set_if_empty(reward_token);
    }

    #[upgrade]
    fn upgrade(&self) {}

    #[payable("*")]
    #[endpoint(stake)]
    fn stake(&self) {
        let (token_id, amount) =
            self.call_value().single_fungible_esdt();
        require!(token_id == self.staking_token().get(), "Wrong token ID.");
        require!(amount > BigUint::zero(), "Amount must be greater than 0");
        
        let caller =
            self.blockchain().get_caller();
        self.staked_balances(&caller).set(self.staked_balances(&caller).get() + &amount);
        self.staked_timestamps(&caller).set(self.blockchain().get_block_timestamp());
    }

    #[payable("*")]
    #[endpoint(unstake)]
    fn unstake(&self) {
        let caller =
            self.blockchain().get_caller();
        let staked_amount =
            self.staked_balances(&caller).get();
        require!(staked_amount > BigUint::zero(), "Nothing staked");
        let staked_timestamp = self.staked_timestamps(&caller).get();
        let current_timestamp = self.blockchain().get_block_timestamp();
        require!(
            current_timestamp > staked_timestamp + self.staking_duration().get(),
            "Staking period not over"
        );
        let staking_time = current_timestamp - staked_timestamp;
        let rewards =
            &staked_amount * YEARLY_INTEREST * staking_time / (BPS * SECONDS_IN_YEAR);

        self.staked_balances(&caller).clear();

        self.send().direct_esdt(&caller, &self.staking_token().get(), 0, &staked_amount);
        self.send().direct_esdt(&caller, &self.reward_token().get(), 0, &rewards);
    }

    #[payable("*")]
    #[endpoint(add_rewards)]
    fn add_rewards(&self) {
        let (token_id, amount) =
            self.call_value().single_fungible_esdt();
        require!(token_id == self.reward_token().get(), "Wrong token ID.");
        require!(amount > BigUint::zero(), "Amount must be greater than 0");
    }

}

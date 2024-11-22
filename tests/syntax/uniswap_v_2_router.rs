// This contract is a translation of UniswapV2Router02 in
// https://github.com/Pi-Squared-Inc/pi2-examples/blob/fed5482baee62b60a080b1d426ffb10db463831e/solidity/src/swaps/UniswapV2Swap.sol
//
// Changes:
// * Various things related to the fact that contracts do not make transfers on
//   behalf of users. In particular, `swap_tokens_for_exact_tokens` receives the
//   max amount of input token, and sends the remainder to the caller.
#![no_std]

#[allow(unused_imports)]
use multiversx_sc::imports::*;

mod pair_proxy {
    multiversx_sc::imports!();

    #[multiversx_sc::proxy]
    pub trait UniswapV2PairProxy {
        #[view(getToken0)]
        #[storage_mapper("token0")]
        fn token0(&self) -> SingleValueMapper<TokenIdentifier>;

        #[view(getToken1)]
        #[storage_mapper("token1")]
        fn token1(&self) -> SingleValueMapper<TokenIdentifier>;

        #[view(getReserve0)]
        #[storage_mapper("reserve0")]
        fn reserve0(&self) -> SingleValueMapper<BigUint>;

        #[view(getReserve1)]
        #[storage_mapper("reserve1")]
        fn reserve1(&self) -> SingleValueMapper<BigUint>;

        #[endpoint]
        fn swap(&self, amount0_out: &BigUint, amount1_out: &BigUint, to: &ManagedAddress);

        #[endpoint]
        fn sync(&self);
    }
}

#[multiversx_sc::contract]
pub trait UniswapV2Router {
    #[init]
    fn init(&self) {
    }

    #[upgrade]
    fn upgrade(&self) {}

    #[view(getLocalPair)]
    #[storage_mapper("local_pairs")]
    fn local_pairs(&self, token0: &TokenIdentifier, token1: &TokenIdentifier) -> SingleValueMapper<ManagedAddress>;

    #[payable("*")]
    #[endpoint(swapExactTokensForTokens)]
    fn swap_exact_tokens_for_tokens(
        &self,
        amount_out_min: BigUint,
        to: &ManagedAddress,
        path: MultiValueEncoded<TokenIdentifier>,
    ) -> MultiValueEncoded<BigUint> {
        let (token_in_id, amount_in) = self.call_value().single_fungible_esdt();
        require!(BigUint::zero() < amount_in, "Expected non-zero amount");

        let path_vec = path.to_vec();

        require!(path_vec.len() >= 2, "Expected non-trivial path.");
        require!(path_vec.get(0).clone_value() == token_in_id, "Expected payment for the first path element");

        let amounts =
                self.uniswap_v2_library_get_amounts_out(amount_in.clone(), &path_vec);
        require!(amounts.get(amounts.len() - 1).clone_value() >= amount_out_min, "UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT");

        let first_pair =
            self.get_local_pair_checked(
                &token_in_id,
                &path_vec.get(1).clone_value()
            );
        self.send().direct_esdt(&first_pair, &token_in_id, 0, &amount_in);

        self._swap(&amounts, &path_vec, &to);
        amounts.into()
    }

    #[payable("*")]
    #[endpoint(swapTokensForExactTokens)]
    fn swap_tokens_for_exact_tokens(
        &self,
        amount_out: BigUint,
        to: &ManagedAddress,
        path: MultiValueEncoded<TokenIdentifier>,
    ) -> MultiValueEncoded<BigUint> {
        let (token_in_id, amount_in) = self.call_value().single_fungible_esdt();
        require!(BigUint::zero() < amount_in, "Expected non-zero amount");

        let path_vec = path.to_vec();

        require!(path_vec.len() >= 2, "Expected non-trivial path.");
        require!(path_vec.get(0).clone_value() == token_in_id, "Expected payment for the first path element");

        let amounts =
                self.uniswap_v2_library_get_amounts_in(&amount_out, &path_vec);

        let amount_in_needed = amounts.get(0).clone_value();
        require!(amount_in_needed <= amount_in, "UniswapV2Router: EXCESSIVE_INPUT_AMOUNT");
        if amount_in_needed < amount_in {
            self.send().direct_esdt(
                &self.blockchain().get_caller(), &token_in_id, 0, &(amount_in - &amount_in_needed)
            );
        };

        let first_pair =
            self.get_local_pair_checked(
                &token_in_id,
                &path_vec.get(1).clone_value()
            );
        self.send().direct_esdt(&first_pair, &token_in_id, 0, &amount_in_needed);

        self._swap(&amounts, &path_vec, &to);
        amounts.into()
    }

    #[endpoint(setLocalPair)]
    fn set_local_pair(&self, token_a: &TokenIdentifier, token_b: &TokenIdentifier, pair: &ManagedAddress) {
        self.local_pairs(token_a, token_b).set(pair);
        self.local_pairs(token_b, token_a).set(pair);
    }

    #[view(getLocalPairChecked)]
    fn get_local_pair_checked(&self, token_a: &TokenIdentifier, token_b: &TokenIdentifier) -> ManagedAddress {
        let pair_address = self.local_pairs(token_a, token_b).get();
        require!(pair_address != ManagedAddress::zero(), "Pair not found");
        pair_address
    }

    #[endpoint(syncLocalPair)]
    fn sync_local_pair(&self, token_a: &TokenIdentifier, token_b: &TokenIdentifier) {
        let pair_address = self.get_local_pair_checked(token_a, token_b);
        self.sync(pair_address);
    }

    fn _swap(&self, amounts: &ManagedVec<BigUint>, path: &ManagedVec<TokenIdentifier>, final_to: &ManagedAddress) {
        for i in 0 .. path.len() - 1 {
            let input = path.get(i).clone_value();
            let output = path.get(i + 1).clone_value();
            let pair_address = self.get_local_pair_checked(&input, &output);
            let pair_token0 = self.token0(pair_address.clone());

            let amount_out = amounts.get(i + 1).clone_value();
            let (amount0_out, amount1_out) = if input == pair_token0 {
                (BigUint::zero(), amount_out)
            } else {
                (amount_out, BigUint::zero())
            };
            let to = if i < path.len() - 2 {
                &self.get_local_pair_checked(&output, &path.get(i + 2).clone_value())
            } else {
                final_to
            };

            self.swap(pair_address, &amount0_out, &amount1_out, to);
        }
    }

    fn uniswap_v2_library_get_amounts_out(
        &self, amount_in: BigUint, path: &ManagedVec<TokenIdentifier>
    ) -> ManagedVec<BigUint> {
        require!(path.len() >= 2, "UniswapV2Library: INVALID_PATH");
        let mut amounts:ManagedVec<BigUint> = ManagedVec::new();
        amounts.push(amount_in);
        for i in 1 .. path.len() {
            let (reserve0, reserve1) =
                self.uniswap_v2_library_get_reserves(
                    &path.get(i - 1).clone_value(), &path.get(i).clone_value()
                );
            let amount =
                self.uniswap_v2_library_get_amount_out(&amounts.get(i - 1), &reserve0, &reserve1);
            amounts.push(amount);
        };
        amounts
    }

    fn uniswap_v2_library_get_amount_out(&self, amount_in: &BigUint, reserve_in: &BigUint, reserve_out: &BigUint) -> BigUint {
        require!(amount_in > &BigUint::zero(), "UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT");
        require!(reserve_in > &BigUint::zero() && reserve_out > &BigUint::zero(), "UniswapV2Library: INSUFFICIENT_LIQUIDITY");
        let amount_in_with_fee = amount_in * 997_u64;
        let numerator = &amount_in_with_fee * reserve_out;
        let denominator = reserve_in * 1000_u64 + amount_in_with_fee;
        numerator / denominator
    }

    fn uniswap_v2_library_get_reserves(&self, token_a: &TokenIdentifier, token_b: &TokenIdentifier) -> (BigUint, BigUint) {
        let pair_address = self.get_local_pair_checked(token_a, token_b);

        if token_a == &self.token0(pair_address.clone()) {
            (self.reserve0(pair_address.clone()), self.reserve1(pair_address.clone()))
        } else {
            (self.reserve1(pair_address.clone()), self.reserve0(pair_address))
        }
    }

    fn uniswap_v2_library_get_amounts_in(
        &self, amount_out: &BigUint, path: &ManagedVec<TokenIdentifier>
    ) -> ManagedVec<BigUint> {
        require!(path.len() >= 2, "UniswapV2Library: INVALID_PATH");
        let mut amounts:ManagedVec<BigUint> = ManagedVec::new();
        for _ in 0 .. path.len() {
            amounts.push(BigUint::zero());
        };

        require!(amounts.set(amounts.len() - 1, amount_out).is_ok(), "Internal error 1");
        for i in 1 .. path.len() {
            let pos_out = path.len() - i;
            let pos_in = pos_out - 1;
            let (reserve0, reserve1) =
                self.uniswap_v2_library_get_reserves(
                    &path.get(pos_in).clone_value(),
                    &path.get(pos_out).clone_value()
                );
            let amount_in =
                self.uniswap_v2_library_get_amount_in(
                    &amounts.get(pos_out).clone_value(),
                    &reserve0,
                    &reserve1
                );
            require!(amounts.set(pos_in, &amount_in).is_ok(), "Internal; error 2");
        };
        amounts
    }

    fn uniswap_v2_library_get_amount_in(
        &self, amount_out: &BigUint, reserve_in: &BigUint, reserve_out: &BigUint
    ) -> BigUint {
        require!(amount_out > &BigUint::zero(), "UniswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT");
        require!(reserve_in > &BigUint::zero() && reserve_out > &BigUint::zero(), "UniswapV2Library: INSUFFICIENT_LIQUIDITY");
        let numerator = reserve_in * amount_out * 1000_u64;
        let denominator = (reserve_out - amount_out) * 997_u64;
        if denominator != 0 {
            (numerator / denominator) + 1_u64
        } else {
            BigUint::from(1_u64)
        }
    }

    #[proxy]
    fn pair_proxy(&self, sc_address: ManagedAddress) -> pair_proxy::Proxy<Self::Api>;

    fn token0(&self, pair: ManagedAddress) -> TokenIdentifier {
        self.pair_proxy(pair)
            .token0()
            .execute_on_dest_context()
    }

    fn reserve0(&self, pair: ManagedAddress) -> BigUint {
        self.pair_proxy(pair)
            .reserve0()
            .execute_on_dest_context()
    }

    fn reserve1(&self, pair: ManagedAddress) -> BigUint {
        self.pair_proxy(pair)
            .reserve1()
            .execute_on_dest_context()
    }

    fn swap(
        &self,
        pair: ManagedAddress,
        amount0_out: &BigUint,
        amount1_out: &BigUint,
        to: &ManagedAddress
    ) {
        let _: IgnoreValue = self
            .pair_proxy(pair)
            .swap(amount0_out, amount1_out, to)
            .execute_on_dest_context();
    }

    fn sync(
      &self,
      pair: ManagedAddress,
    ) {
        let _: IgnoreValue = self
            .pair_proxy(pair)
            .sync()
            .execute_on_dest_context();
    }

}

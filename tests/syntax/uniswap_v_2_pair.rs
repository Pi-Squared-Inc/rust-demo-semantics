// This contract is a translation of UniswapV2Pair in
// https://github.com/Pi-Squared-Inc/pi2-examples/blob/fed5482baee62b60a080b1d426ffb10db463831e/solidity/src/swaps/UniswapV2Swap.sol
//
// Changes:
// * Removed the getReserves endpoint
// * Changed the timestamp computation in _update
#![no_std]

#[allow(unused_imports)]
use multiversx_sc::imports::*;

pub const MINIMUM_LIQUIDITY: u64 = 1000;

#[multiversx_sc::contract]
pub trait UniswapV2Pair {
    #[init]
    fn init(&self, token0: &TokenIdentifier, token1: &TokenIdentifier) {
        self.token0().set_if_empty(token0);
        self.token1().set_if_empty(token1);
    }

    #[upgrade]
    fn upgrade(&self) {}

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

    #[view(getBlockTimestampLast)]
    #[storage_mapper("blockTimestampLast")]
    fn block_timestamp_last(&self) -> SingleValueMapper<u64>;

    #[view(getPrice0CumulativeLast)]
    #[storage_mapper("price0CumulativeLast")]
    fn price0_cumulative_last(&self) -> SingleValueMapper<BigUint>;

    #[view(getPrice1CumulativeLast)]
    #[storage_mapper("price1CumulativeLast")]
    fn price1_cumulative_last(&self) -> SingleValueMapper<BigUint>;

    #[view(getTotalSupply)]
    #[storage_mapper("totalSupply")]
    fn total_supply(&self) -> SingleValueMapper<BigUint>;

    #[view(getKLast)]
    #[storage_mapper("kLast")]
    fn k_last(&self) -> SingleValueMapper<BigUint>;

    #[endpoint]
    fn swap(
        &self,
        amount0_out: &BigUint,
        amount1_out: &BigUint,
        to: &ManagedAddress
    ) {
        require!(amount0_out > &BigUint::zero() || amount1_out > &BigUint::zero(), "UniswapV2: INSUFFICIENT_OUTPUT_AMOUNT");

        let token0 = self.token0().get();
        let token1 = self.token1().get();
        let reserve0 = self.reserve0().get();
        let reserve1 = self.reserve1().get();

        require!(amount0_out <= &reserve0 && amount1_out <= &reserve1, "UniswapV2: INSUFFICIENT_LIQUIDITY");

        if amount0_out > &BigUint::zero() {
            self.send().direct_esdt(to, &token0, 0, amount0_out);
        };
        if amount1_out > &BigUint::zero() {
            self.send().direct_esdt(to, &token1, 0, amount1_out);
        };

        let balance0 = self.balance(&token0);
        let balance1 = self.balance(&token1);

        let amount0_in = if balance0 > &reserve0 - amount0_out {
            &balance0 - &(&reserve0 - amount0_out)
        } else {
            BigUint::zero()
        };
        let amount1_in = if balance1 > &reserve1 - amount1_out {
            &balance1 - &(&reserve1 - amount1_out)
        } else {
            BigUint::zero()
        };
        require!(amount0_in > 0 || amount1_in > 0, "UniswapV2: INSUFFICIENT_INPUT_AMOUNT");
        let balance0_adjusted =
                (&balance0 * 1000_u64) - (amount0_in * 3_u64);
        let balance1_adjusted =
                (&balance1 * 1000_u64) - (amount1_in * 3_u64);
        require!(
            balance0_adjusted * balance1_adjusted >= &reserve0 * &reserve1 * 1_000_000_u64,
            "UniswapV2: K"
        );

        self._update(&balance0, &balance1, &reserve0, &reserve1);
    }

    #[payable("*")]
    #[endpoint]
    fn sync(&self) {
        let token0 = self.token0().get();
        let token1 = self.token1().get();
        let balance0 = self.balance(&token0);
        let balance1 = self.balance(&token1);
        let reserve0 = self.reserve0().get();
        let reserve1 = self.reserve1().get();
        self._update(&balance0, &balance1, &reserve0, &reserve1);
    }

    fn _update(&self, balance0: &BigUint, balance1: &BigUint, reserve0: &BigUint, reserve1: &BigUint) {
        let block_timestamp = self.blockchain().get_block_timestamp();
        let last_block_timestamp = self.block_timestamp_last().get();
        let time_elapsed = block_timestamp - last_block_timestamp;
        if time_elapsed > 0 && reserve0 != &BigUint::zero() && reserve1 != &BigUint::zero() {
            self.price0_cumulative_last().set(
                self.price0_cumulative_last().get() + (reserve1/reserve0) * time_elapsed
            );
            self.price1_cumulative_last().set(
                self.price1_cumulative_last().get() + (reserve0/reserve1) * time_elapsed
            );
        };
        self.reserve0().set(balance0);
        self.reserve1().set(balance1);
        self.block_timestamp_last().set(block_timestamp);
    }

    fn balance(&self, token: &TokenIdentifier) -> BigUint {
        self.blockchain().get_sc_balance(&EgldOrEsdtTokenIdentifier::esdt(token.clone()), 0)
    }
}

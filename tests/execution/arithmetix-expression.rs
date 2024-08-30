#![no_std]

#[allow(unused_imports)]
use multiversx_sc::imports::*;

#[multiversx_sc::contract]
pub trait ArithmeticExpression {
    #[init]
    fn init(&self) {
    }

    #[upgrade]
    fn upgrade(&self) {}

    fn arithmetic_expression_constant(&self) -> u64 { 24_u64 * 60_u64 * 60_u64 }

}

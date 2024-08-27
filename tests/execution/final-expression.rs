#![no_std]

#[allow(unused_imports)]
use multiversx_sc::imports::*;

#[multiversx_sc::contract]
pub trait FinalExpression {
    #[init]
    fn init(&self) {
    }

    #[upgrade]
    fn upgrade(&self) {}

    fn constant(&self) -> u64 { 100_u64 }

    fn constant_cast(&self) -> u64 { 100 }
}

#![no_std]

#[allow(unused_imports)]
use multiversx_sc::imports::*;

#[multiversx_sc::contract]
pub trait FunctionCalls {
    #[init]
    fn init(&self) {
    }

    #[upgrade]
    fn upgrade(&self) {}

    fn call_empty(&self) {
        self.empty()
    }
    fn empty(&self) {}

    fn call_one(&self) -> u64 {
        self.one()
    }
    fn one(&self) -> u64 { 1u64 }

    fn call_sum(&self) -> u64 {
        self.sum(1u64, 2u64)
    }
    fn sum(&self, first: u64, second: u64) -> u64 { first + second }

    fn call_ref(&self) -> u64 {
        self.sum_ref(&1u64, &2u64)
    }
    fn sum_ref(&self, first: &u64, second: &u64) -> u64 { first + second }

    fn call_chained(&self) -> u64 {
        self.get_self().one()
    }
    fn get_self(&self) -> FunctionCalls { self }
}

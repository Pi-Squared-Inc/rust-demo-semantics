#![no_std]

#[allow(unused_imports)]
use multiversx_sc::imports::*;

#[multiversx_sc::contract]
pub trait Empty {
    #[init]
    fn init(&self) {
    }

    #[upgrade]
    fn upgrade(&self) {}

    fn self_with_comma(&self, ) {}

    fn self_and_arg(&self, first: BigUint) {}

    fn self_and_args(&self, first: BigUint, second: BigUint) {}

    fn self_and_args_comma(&self, first: BigUint, second: BigUint, ) {}

    fn reference_arg(&self, first: &BigUint) {}
}

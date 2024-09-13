#![no_std]

#[allow(unused_imports)]
use multiversx_sc::imports::*;

#[multiversx_sc::contract]
pub trait Storage {
    #[view(noArg)]
    #[storage_mapper("no_arg")]
    fn no_arg_storage(&self) -> SingleValueMapper<BigUint>;

    #[view(getName)]
    #[storage_mapper("name")]
    fn one_arg_storage(&self, key: u64) -> SingleValueMapper<BigUint>;

    #[init]
    fn init(&self) {}

    #[upgrade]
    fn upgrade(&self) {}

    fn set_no_arg(&self, value: u64) {
        self.no_arg_storage().set(BigUint::from(value))
    }

    fn get_no_arg(&self) -> BigUint {
        self.no_arg_storage().get()
    }

    fn set_no_arg_if_empty(&self, value: u64) {
        self.no_arg_storage().set_if_empty(BigUint::from(value))
    }
}

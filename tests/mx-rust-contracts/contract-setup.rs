#![no_std]

#[allow(unused_imports)]
use multiversx_sc::imports::*;

#[multiversx_sc::contract]
pub trait Storage {
    #[view(noArg)]
    #[storage_mapper("no_arg")]
    fn my_storage(&self) -> SingleValueMapper<BigUint>;

    #[init]
    fn init(&self) {
        self.my_storage().set_if_empty(BigUint::from(10))
    }

    #[upgrade]
    fn upgrade(&self) {}

    #[endpoint(getMyStorage)]
    fn get_my_storage(&self) -> BigUint {
        self.my_storage().get()
    }
}

#![no_std]

#[allow(unused_imports)]
use multiversx_sc::imports::*;

#[multiversx_sc::contract]
pub trait Storage {
    #[view(noArg)]
    #[storage_mapper("my_storage")]
    fn my_storage(&self) -> SingleValueMapper<BigUint>;

    #[init]
    fn init(&self, value: &BigUint) {
        self.my_storage().set_if_empty(value)
    }

    #[upgrade]
    fn upgrade(&self) {}

    #[endpoint(getMyStorage)]
    fn get_my_storage(&self) -> BigUint {
        self.my_storage().get()
    }
}

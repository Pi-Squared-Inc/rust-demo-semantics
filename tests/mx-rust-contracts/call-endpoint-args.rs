#![no_std]

#[allow(unused_imports)]
use multiversx_sc::imports::*;

#[multiversx_sc::contract]
pub trait Contract {
    #[view(noArg)]
    #[storage_mapper("my_value")]
    fn my_storage(&self) -> SingleValueMapper<BigUint>;

    #[init]
    fn init(&self) {}

    #[upgrade]
    fn upgrade(&self) {}

    #[endpoint(setMyStorage)]
    fn set_my_storage(&self, value: &BigUint) {
        self.my_storage().set(value)
    }

    #[endpoint(getMyStorage)]
    fn get_my_storage(&self) -> BigUint {
        self.my_storage().get()
    }
}

#![no_std]

#[allow(unused_imports)]
use multiversx_sc::imports::*;

#[multiversx_sc::contract]
pub trait Contract {
    #[init]
    fn init(&self) {}

    #[upgrade]
    fn upgrade(&self) {}

    #[payable("*")]
    #[endpoint(getTransfer)]
    fn get_transfer(&self) -> (str, BigUint) {
        self.call_value().single_fungible_esdt()
    }
}

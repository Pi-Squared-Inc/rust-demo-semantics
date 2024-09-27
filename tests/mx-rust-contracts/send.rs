#![no_std]

#[allow(unused_imports)]
use multiversx_sc::imports::*;

#[multiversx_sc::contract]
pub trait Storage {
    #[init]
    fn init(&self) {}

    #[upgrade]
    fn upgrade(&self) {}

    #[endpoint(sendTo)]
    fn send_to(&self, address: ManagedAddress, token: TokenIdentifier, amount: BigUint) {
        self.send().direct_esdt(address, token, 0_u64, amount);
    }
}

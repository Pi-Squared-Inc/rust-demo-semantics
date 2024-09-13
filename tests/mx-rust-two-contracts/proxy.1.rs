#![no_std]

#[allow(unused_imports)]
use multiversx_sc::imports::*;

mod my_proxy {
    multiversx_sc::imports!();

    #[multiversx_sc::proxy]
    pub trait Storage {
        #[endpoint(getMyStorage)]
        fn get_my_storage(&self) -> BigUint;

        #[endpoint(setMyStorage)]
        fn set_my_storage(&self, value: &BigUint);
    }
}

#[multiversx_sc::contract]
pub trait Caller {
    #[init]
    fn init(&self) {}

    #[upgrade]
    fn upgrade(&self) {}

    #[endpoint(getStorage)]
    fn get_storage(&self, address: ManagedAddress) -> BigUint {
        self.storage_proxy(address)
            .get_my_storage()
            .execute_on_dest_context()
    }

    #[endpoint(setStorage)]
    fn set_my_storage(&self, address: ManagedAddress, value: BigUint) {
        self.storage_proxy(address)
            .set_my_storage(value)
            .execute_on_dest_context()
    }

    #[proxy]
    fn storage_proxy(&self, sc_address: ManagedAddress) -> my_proxy::Proxy<Self::Api>;
}

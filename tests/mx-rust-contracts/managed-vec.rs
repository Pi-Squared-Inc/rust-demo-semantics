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
    #[endpoint(zeroSize)]
    fn new_size(&self) -> u64 {
        let mut values:ManagedVec<BigUint> = ManagedVec::new();
        values.len()
    }

    #[payable("*")]
    #[endpoint(pushGet)]
    fn push_get(&self, value:u64) -> BigUint {
        let mut values:ManagedVec<BigUint> = ManagedVec::new();
        values.push(BigUint::from(value));
        values.get(0).clone_value()
    }

    #[payable("*")]
    #[endpoint(pushSize)]
    fn push_size(&self) -> u64 {
        let mut values:ManagedVec<BigUint> = ManagedVec::new();
        values.push(BigUint::from(1_u64));
        values.push(BigUint::from(2_u64));
        values.len()
    }

    #[payable("*")]
    #[endpoint(pushPushGet)]
    fn push_push_get(&self, value1:u64, value2:u64) -> BigUint {
        let mut values:ManagedVec<BigUint> = ManagedVec::new();
        values.push(BigUint::from(value1));
        values.push(BigUint::from(value2));
        values.get(1).clone_value()
    }

    #[payable("*")]
    #[endpoint(setGet)]
    fn set_get(&self, value:u64) -> BigUint {
        let mut values:ManagedVec<BigUint> = ManagedVec::new();
        values.push(BigUint::from(1));
        values.push(BigUint::from(2));
        values.set(1, BigUint::from(value));
        values.get(1).clone_value()
    }
}

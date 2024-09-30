#![no_std]

#[allow(unused_imports)]
use multiversx_sc::imports::*;

#[multiversx_sc::contract]
pub trait Contract {
    #[init]
    fn init(&self) {}

    #[upgrade]
    fn upgrade(&self) {}

    #[endpoint(toVecGet)]
    fn to_vec_get(&self, v: MultiValueEncoded<BigUint>, idx: u64) -> BigUint {
        let mut values:ManagedVec<BigUint> = v.to_vec();
        values.get(idx)
    }

    #[endpoint(intoMve)]
    fn into_mve(&self, a: u64, b:u64) -> MultiValueEncoded<BigUint> {
        let mut values:ManagedVec<BigUint> = ManagedVec::new();
        values.push(BigUint::from(a));
        values.push(BigUint::from(b));
        values.into()
    }
}

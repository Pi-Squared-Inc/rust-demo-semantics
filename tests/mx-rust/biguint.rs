#![no_std]

#[allow(unused_imports)]
use multiversx_sc::imports::*;

#[multiversx_sc::contract]
pub trait BigUintTest {
    #[init]
    fn init(&self) {}

    #[upgrade]
    fn upgrade(&self) {}

    fn zero(&self) -> BigUint {
        BigUint::zero()
    }

    fn add(&self, a: u64, b: u64) -> BigUint {
        BigUint::from(a) + BigUint::from(b)
    }

    fn sub(&self, a: u64, b: u64) -> BigUint {
        BigUint::from(a) - BigUint::from(b)
    }

    fn mul(&self, a: u64, b: u64) -> BigUint {
        BigUint::from(a) * BigUint::from(b)
    }

    fn div(&self, a: u64, b: u64) -> BigUint {
        BigUint::from(a) / BigUint::from(b)
    }

    fn lt(&self, a: u64, b: u64) -> bool {
        BigUint::from(a) < BigUint::from(b)
    }

    fn le(&self, a: u64, b: u64) -> bool {
        BigUint::from(a) <= BigUint::from(b)
    }

    fn gt(&self, a: u64, b: u64) -> bool {
        BigUint::from(a) > BigUint::from(b)
    }

    fn ge(&self, a: u64, b: u64) -> bool {
        BigUint::from(a) >= BigUint::from(b)
    }

    fn eq(&self, a: u64, b: u64) -> bool {
        BigUint::from(a) == BigUint::from(b)
    }

    fn ne(&self, a: u64, b: u64) -> bool {
        BigUint::from(a) != BigUint::from(b)
    }

    fn add64(&self, a: u64, b: u64) -> BigUint {
        BigUint::from(a) + b
    }

    fn sub64(&self, a: u64, b: u64) -> BigUint {
        BigUint::from(a) - b
    }

    fn mul64(&self, a: u64, b: u64) -> BigUint {
        BigUint::from(a) * b
    }

    fn div64(&self, a: u64, b: u64) -> BigUint {
        BigUint::from(a) / b
    }
}

#![no_std]

#[allow(unused_imports)]
use multiversx_sc::imports::*;

#[multiversx_sc::contract]
pub trait Let {
    #[init]
    fn init(&self) {
    }

    #[upgrade]
    fn upgrade(&self) {}

    fn let_final(&self) -> u64 {
        let x = 100_u64;
        x
    }

    fn let_mut(&self) -> u64 {
        let mut x = 99_u64;
        x = 100_u64;
        x
    }

    fn let_tuple(&self) -> u64 {
        let (x, y, z, w,) = (100_u64, 99_u64, 98_u64, 97_u64);
        x
    }
}

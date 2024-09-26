#![no_std]

#[allow(unused_imports)]
use multiversx_sc::imports::*;

#[multiversx_sc::contract]
pub trait LetMut {
    #[init]
    fn init(&self) {
    }

    #[upgrade]
    fn upgrade(&self) {}

    fn let_mut(&self) -> u64 {
        let mut x = 99_u64;
        x = 100_u64;
        x
    }
}

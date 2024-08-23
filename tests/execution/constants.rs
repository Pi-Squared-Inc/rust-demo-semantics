#![no_std]

#[allow(unused_imports)]
use multiversx_sc::imports::*;

pub const UNSIGNED_CONSTANT: u64 = 10_u64;
pub const SIGNED_CONSTANT: u32 = 10;
pub const LARGE_CONSTANT: u64 = 100_000_u64;

#[multiversx_sc::contract]
pub trait Empty {
    #[init]
    fn init(&self) {
    }

    #[upgrade]
    fn upgrade(&self) {}

}

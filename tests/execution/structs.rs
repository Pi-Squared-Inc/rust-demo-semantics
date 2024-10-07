#![no_std]

#[allow(unused_imports)]
use multiversx_sc::imports::*;

struct Pair{i: u32, j: u32 }

#[multiversx_sc::contract]
pub trait StructFile {
    #[init]
    fn init(&self) {
    }

    #[upgrade]
    fn upgrade(&self) {}

    fn empty(&self) {}
}

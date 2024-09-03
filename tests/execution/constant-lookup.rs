#![no_std]

#[allow(unused_imports)]
use multiversx_sc::imports::*;

pub const YEARLY_INTEREST: u64 = 7_000;

#[multiversx_sc::contract]
pub trait ConstantValueLookup {
    #[init]
    fn init(&self) {
    }

    #[upgrade]
    fn upgrade(&self) {}

    fn lookup_constant(&self) -> u64 { YEARLY_INTEREST }

    fn lookup_constant_with_type(&self) -> u64 { 
        let x = YEARLY_INTEREST;
        x 
    }

}

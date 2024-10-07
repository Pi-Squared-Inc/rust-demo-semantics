#![no_std]

#[allow(unused_imports)]
use multiversx_sc::imports::*;

pub const SAMPLE_CONSTANT: u64 = 7_000;

#[multiversx_sc::contract]
pub trait ConstantValueLookup {
    #[init]
    fn init(&self) {
    }

    #[upgrade]
    fn upgrade(&self) {}

    fn lookup_constant(&self) -> u64 { :: constant_lookup :: SAMPLE_CONSTANT }

    fn lookup_constant_with_type(&self) -> u64 { 
        let x = 100_u64 + :: constant_lookup :: SAMPLE_CONSTANT;
        x 
    }

}

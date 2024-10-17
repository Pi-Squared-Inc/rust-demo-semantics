#![no_std]

#[allow(unused_imports)]
use ukm::*;

#[ukm::contract]
pub trait Endpoints {
    #[init]
    fn init(&self) {}

    #[endpoint(myEndpoint)]
    fn endpoint(&self, value: u64) -> u64 {
        ::helpers::require(value != 0_u64, "require test");
        value + 3_u64
    }
}

#![no_std]

#[allow(unused_imports)]
use ukm::*;

#[ukm::contract]
pub trait Endpoints {
    #[init]
    fn init(&self) {}

    #[endpoint(myEndpoint)]
    fn endpoint(&self, value: u64) -> u64 {
        value + 3_u64
    }
}

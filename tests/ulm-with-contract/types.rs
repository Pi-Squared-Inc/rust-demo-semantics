#![no_std]

#[allow(unused_imports)]
use ulm::*;

#[ulm::contract]
pub trait Types {
    #[init]
    fn init(&self) {}

    #[endpoint(strEndpoint)]
    fn str_endpoint(&self) -> str {
        "Hello"
    }
}

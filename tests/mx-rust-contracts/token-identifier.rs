#![no_std]

#[allow(unused_imports)]
use multiversx_sc::imports::*;

#[multiversx_sc::contract]
pub trait Storage {
    #[init]
    fn init(&self) {}

    #[upgrade]
    fn upgrade(&self) {}

    #[endpoint(testEquality)]
    fn test_equality(&self, t1: TokenIdentifier, t2:TokenIdentifier) -> bool {
        t1 == t2
    }

    #[endpoint(testClone)]
    fn test_clone(&self, t: TokenIdentifier) -> TokenIdentifier {
        t.clone()
    }
}

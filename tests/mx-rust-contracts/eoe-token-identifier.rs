#![no_std]

#[allow(unused_imports)]
use multiversx_sc::imports::*;

#[multiversx_sc::contract]
pub trait Contract {
    #[init]
    fn init(&self) {}

    #[upgrade]
    fn upgrade(&self) {}

    #[endpoint(eoeTokenIdentifier)]
    fn eoe_token_identifier(&self, t: TokenIdentifier) -> EgldOrEsdtTokenIdentifier {
        EgldOrEsdtTokenIdentifier::from(t)
    }
}

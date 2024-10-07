#![no_std]

#[allow(unused_imports)]
use multiversx_sc::imports::*;

#[multiversx_sc::contract]
pub trait Empty {
    #[init]
    fn init(&self) {
    }

    #[upgrade]
    fn upgrade(&self) {}

    #[view(getTokens)]
    #[storage_mapper("tokens")]
    fn tokens(&self) -> UnorderedSetMapper<TokenIdentifier>;

}

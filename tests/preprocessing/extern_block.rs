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

}

extern "C" {
  fn f();
  fn g(V:u64) -> u64;
}

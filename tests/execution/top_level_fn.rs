#![no_std]

#[allow(unused_imports)]
use multiversx_sc::imports::*;

#[multiversx_sc::contract]
pub trait TopLevelFn {
    #[init]
    fn init(&self) {
    }

    #[upgrade]
    fn upgrade(&self) {}
    
    fn call_top_level(&self, v: u64) -> u64 { 
      ::top_level_fn::top_level(v)
    }
}

fn top_level(v: u64) -> u64 {
  v + 3_u64
}
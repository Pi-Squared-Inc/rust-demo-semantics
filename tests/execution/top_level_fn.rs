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

    fn call_top_level_no_arg(&self) -> u64 {
      ::top_level_fn::top_level_no_arg()
    }
}

fn top_level(v: u64) -> u64 {
  v + 3_u64
}

fn top_level_no_arg() -> u64 {
  3_u64
}

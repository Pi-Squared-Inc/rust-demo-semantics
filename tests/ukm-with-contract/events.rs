#![no_std]

#[allow(unused_imports)]
use ukm::*;

#[ukm::contract]
pub trait Events {
  #[event("MyEvent")]
  fn my_event(&self, #[indexed] from: u64, value: u64);

  #[init]
  fn init(&self) {}

  #[endpoint(logEvent)]
  fn log_event(&self, from:u64, value: u64) {
      self.my_event(from, value)
  }
}

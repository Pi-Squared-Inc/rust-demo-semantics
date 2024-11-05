#![no_std]

#[allow(unused_imports)]
use ulm::*;

#[ulm::contract]
pub trait Storage {
  #[storage_mapper("myData")]
  fn my_data(&self) -> ::single_value_mapper::SingleValueMapper<u64>;

  #[storage_mapper("myData256")]
  fn my_data_256(&self) -> ::single_value_mapper::SingleValueMapper<u256>;

  #[storage_mapper("myDataKey")]
  fn my_data_key(&self, key: u64) -> ::single_value_mapper::SingleValueMapper<u64>;

  #[init]
  fn init(&self) {}

  #[endpoint(setMyData)]
  fn set(&self, value: u64) {
      self.my_data().set(value)
  }

  #[endpoint(getMyData)]
  fn get(&self) -> u64 {
      self.my_data().get()
  }

  #[endpoint(setMyData256)]
  fn set_256(&self, value: u256) {
      self.my_data_256().set(value)
  }

  #[endpoint(getMyData256)]
  fn get_256(&self) -> u256 {
      self.my_data_256().get()
  }

  #[endpoint(setMyDataKey)]
  fn set_key(&self, key: u64, value: u64) {
      self.my_data_key(key).set(value)
  }

  #[endpoint(getMyDataKey)]
  fn get_key(&self, key: u64) -> u64 {
      self.my_data_key(key).get()
  }
}

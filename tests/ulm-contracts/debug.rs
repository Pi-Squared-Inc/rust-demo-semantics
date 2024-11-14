extern "C" {
  fn debug_u256(value: u256);
  fn debug_u160(value: u160);
  fn debug_u128(value: u128);
  fn debug_u64(value: u64);
  fn debug_u32(value: u32);
  fn debug_u16(value: u16);
  fn debug_u8(value: u8);
  fn debug_bool(value: bool);
  fn debug_str(value: &str);
  fn debug_unit(value: ());
}

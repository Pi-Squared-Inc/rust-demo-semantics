extern "C" {
  fn empty() -> u64;
  fn length(bytes_id: u64) -> u32;

  fn append_u128(bytes_id: u64, value: u128) -> u64;
  fn append_u64(bytes_id: u64, value: u64) -> u64;
  fn append_u32(bytes_id: u64, value: u32) -> u64;
  fn append_u16(bytes_id: u64, value: u16) -> u64;
  fn append_u8(bytes_id: u64, value: u8) -> u64;
  fn append_bool(bytes_id: u64, value: bool) -> u64;
  fn append_str(bytes_id: u64, value: &str) -> u64;

  fn decode_u128(bytes_id: u64) -> (u64, u128);
  fn decode_u64(bytes_id: u64) -> (u64, u64);
  fn decode_u32(bytes_id: u64) -> (u64, u32);
  fn decode_u16(bytes_id: u64) -> (u64, u16);
  fn decode_u8(bytes_id: u64) -> (u64, u8);
  fn decode_str(bytes_id: u64) -> (u64, str);

  fn decode_signature(bytes_id: u64) -> (u64, str);
}

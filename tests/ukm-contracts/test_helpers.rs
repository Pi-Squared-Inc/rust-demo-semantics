
fn decode_single_u64(bytes_id: u64) -> u64 {
  let (remaining_id, value) = :: bytes_hooks :: decode_u64(bytes_id);
  if :: bytes_hooks :: length(remaining_id) > 0_u32 {
      fail();
  };
  value
}

fn decode_single_u256(bytes_id: u64) -> u256 {
  let (remaining_id, value) = :: bytes_hooks :: decode_u256(bytes_id);
  if :: bytes_hooks :: length(remaining_id) > 0_u32 {
      fail();
  };
  value
}

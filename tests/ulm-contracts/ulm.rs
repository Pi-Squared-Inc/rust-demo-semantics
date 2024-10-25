#![no_std]

// TODO: Support structs and figure out the content of MessageResult
struct MessageResult { gas: u64 }

pub const EVMC_SUCCESS: u64 = 2_u64;
pub const EVMC_REVERT: u64 = 3_u64;
pub const EVMC_BAD_JUMP_DESTINATION: u64 = 8_u64;

extern {
    // message parameters
    fn Caller(&self) -> u160;
    fn CallData(&self) -> Bytes;

    // account getters
    fn GetAccountStorage(&self, key: u256) -> u256;

    fn SetAccountStorage(&self, key: u256, value: u256);
}

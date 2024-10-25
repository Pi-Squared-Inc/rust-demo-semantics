#![no_std]

// TODO: Support structs and figure out the content of MessageResult
struct MessageResult { gas: u256 }

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

    fn Log0(data: Bytes);
    fn Log1(topic0: u256, data: Bytes);
    fn Log2(topic0: u256, topic1: u256, data: Bytes);
    fn Log3(topic0: u256, topic1: u256, topic2: u256, data: Bytes);
    fn Log4(topic0: u256, topic1: u256, topic2: u256, topic3: u256, data: Bytes);
}

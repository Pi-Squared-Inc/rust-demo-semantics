#![no_std]

// TODO: Support structs and figure out the content of MessageResult
struct MessageResult { gas: u256 }

pub const EVMC_REJECTED: u64 = 0_u64;
pub const EVMC_INTERNAL_ERROR: u64 = 1_u64;
pub const EVMC_SUCCESS: u64 = 2_u64;
pub const EVMC_REVERT: u64 = 3_u64;
pub const EVMC_FAILURE: u64 = 4_u64;
pub const EVMC_INVALID_INSTRUCTION: u64 = 5_u64;
pub const EVMC_UNDEFINED_INSTRUCTION: u64 = 6_u64;
pub const EVMC_OUT_OF_GAS: u64 = 7_u64;
pub const EVMC_BAD_JUMP_DESTINATION: u64 = 8_u64;
pub const EVMC_STACK_OVERFLOW: u64 = 9_u64;
pub const EVMC_STACK_UNDERFLOW: u64 = 10_u64;
pub const EVMC_CALL_DEPTH_EXCEEDED: u64 = 11_u64;
pub const EVMC_INVALID_MEMORY_ACCESS: u64 = 12_u64;
pub const EVMC_STATIC_MODE_VIOLATION: u64 = 13_u64;
pub const EVMC_PRECOMPILE_FAILURE: u64 = 14_u64;
pub const EVMC_NONCE_EXCEEDED: u64 = 15_u64;

extern {    
    // block parameters
    fn sample_method(&self) -> u256;
    fn GasLimit(&self) -> u256;
    fn BaseFee(&self) -> u256;
    fn Coinbase(&self) -> u256;
    fn BlockTimestamp(&self) -> u256;
    fn BlockNumber(&self) -> u256;
    fn BlockDifficulty(&self) -> u256;
    fn PrevRandao(&self) -> u256;
    fn BlockHash(&self, index: u256) -> u256;

    // transaction parameters
    fn GasPrice(&self) -> u256;
    fn Origin(&self) -> u256;
    
    // message parameters
    fn Address(&self) -> u160;
    fn Caller(&self) -> u160;
    fn CallValue(&self) -> u256;
    fn CallData(&self) -> Bytes;

    // chain parameters
    fn ChainId(&self) -> u256;
    
    // account getters
    fn GetAccountBalance(&self, acct: u160) -> u256;
    fn GetAccountCode(&self, acct: u160) -> Bytes;
    fn GetAccountStorage(&self, key: u256) -> u256;
    fn GetAccountOrigStorage(&self, key: u256) -> u256;
    fn GetAccountTransientStorage(&self, key: u256) -> u256;
    fn IsAccountEmpty(&self, acct: u160) -> bool;

    // to be removed in final version
    fn AccessedStorage(&self, key: u256) -> bool;
    fn AccessedAccount(&self, acct: u256) -> bool;

    fn Transfer(&self, to: u160, value: u256) -> bool;
    fn SelfDestruct(&self, to: u256);
    fn SetAccountStorage(&self, key: u256, value: u256);
    fn SetAccountTransientStorage(&self, key: u256, value: u256);

    fn Log0(data: Bytes);
    fn Log1(topic0: u256, data: Bytes);
    fn Log2(topic0: u256, topic1: u256, data: Bytes);
    fn Log3(topic0: u256, topic1: u256, topic2: u256, data: Bytes);
    fn Log4(topic0: u256, topic1: u256, topic2: u256, topic3: u256, data: Bytes);
    
    fn MessageResult(gas: u256, data: Bytes, status: u256, target: u256) -> MessageResult;
    fn Create(value: u256, data: Bytes, gas: u256) -> MessageResult;
    fn Create2(value: u256, data: Bytes, salt: Bytes, gas: u256) -> MessageResult;
    fn Call(gas: u256, to: u160, value: u256, data: Bytes) -> MessageResult;
    fn CallCode(gas: u256, to: u160, value: u256, data: Bytes) -> MessageResult;
    fn DelegateCall(gas: u256, to: u160, data: Bytes) -> MessageResult;
    fn StaticCall(gas: u256, to: u160, data: Bytes) -> MessageResult;
}

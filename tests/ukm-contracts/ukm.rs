#![no_std]

// TODO: Support structs and figure out the content of MessageResult
struct MessageResult { }

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
    fn sample_method(&self) -> u64;
    fn GasLimit(&self) -> u64;
    fn BaseFee(&self) -> u64;
    fn Coinbase(&self) -> u64;
    fn BlockTimestamp(&self) -> u64;
    fn BlockNumber(&self) -> u64;
    fn BlockDifficulty(&self) -> u64;
    fn PrevRandao(&self) -> u64;
    fn BlockHash(&self, index: u64) -> u64;

    // transaction parameters
    fn GasPrice(&self) -> u64;
    fn Origin(&self) -> u64;
    
    // message parameters
    fn Address(&self) -> u64;
    fn Caller(&self) -> u64;
    fn CallValue(&self) -> u64;
    fn CallData(&self) -> Bytes;

    // chain parameters
    fn ChainId(&self) -> u64;
    
    // account getters
    fn GetAccountBalance(&self, acct: u64) -> u64;
    fn GetAccountCode(&self, acct: u64) -> u64;
    fn GetAccountStorage(&self, key: u64) -> u64;
    fn GetAccountOrigStorage(&self, key: u64) -> u64;
    fn GetAccountTransientStorage(&self, key: u64) -> u64;
    fn IsAccountEmpty(&self, acct: u64) -> bool;

    // to be removed in final version
    fn AccessedStorage(&self, key: u64) -> bool;
    fn AccessedAccount(&self, acct: u64) -> bool;

    fn Transfer(&self, to: u64, value: u64) -> bool;
    fn SelfDestruct(&self, to: u64);
    fn SetAccountStorage(&self, key: u64, value: u64);
    fn SetAccountTransientStorage(&self, key: u64, value: u64);

    fn Log0(data: Bytes);
    fn Log1(topic0: u64, data: Bytes);
    fn Log2(topic0: u64, topic1: u64, data: Bytes);
    fn Log3(topic0: u64, topic1: u64, topic2: u64, data: Bytes);
    fn Log4(topic0: u64, topic1: u64, topic2: u64, topic3: u64, data: Bytes); 
    
    fn MessageResult(gas: u64, data: Bytes, status: u64, target: u64) -> MessageResult;
    fn Create(value: u64, data: Bytes, gas: u64) -> MessageResult;
    fn Create2(value: u64, data: Bytes, salt: Bytes, gas: u64) -> MessageResult;
    fn Call(gas: u64, to: u64, value: u64, data: Bytes) -> MessageResult;
    fn CallCode(gas: u64, to: u64, value: u64, data: Bytes) -> MessageResult;
    fn DelegateCall(gas: u64, to: u64, data: Bytes) -> MessageResult;
    fn StaticCall(gas: u64, to: u64, data: Bytes) -> MessageResult;
}

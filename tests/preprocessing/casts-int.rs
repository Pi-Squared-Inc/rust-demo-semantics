#![no_std]

#[allow(unused_imports)]
use multiversx_sc::imports::*;

pub const I32_01: i32 = 10_i32;
pub const I32_02: i32 = 10_u32;
pub const I32_03: i32 = 10_i64;
pub const I32_04: i32 = 10_u64;
pub const I32_05: i32 = 10;

pub const U32_01: u32 = 10_i32;
pub const U32_02: u32 = 10_u32;
pub const U32_03: u32 = 10_i64;
pub const U32_04: u32 = 10_u64;
pub const U32_05: u32 = 10;

pub const I64_01: i64 = 10_i32;
pub const I64_02: i64 = 10_u32;
pub const I64_03: i64 = 10_i64;
pub const I64_04: i64 = 10_u64;
pub const I64_05: i64 = 10;

pub const U64_01: u64 = 10_i32;
pub const U64_02: u64 = 10_u32;
pub const U64_03: u64 = 10_i64;
pub const U64_04: u64 = 10_u64;
pub const U64_05: u64 = 10;

#[multiversx_sc::contract]
pub trait Empty {
    #[init]
    fn init(&self) {
    }

    #[upgrade]
    fn upgrade(&self) {}

}

#![no_std]

#[allow(unused_imports)]
use multiversx_sc::imports::*;

pub const  I8_01: i8  = 10_i8;
pub const  I8_02: i8  = 10_u8;
pub const  I8_03: i8  = 10_i16;
pub const  I8_04: i8  = 10_u16;
pub const  I8_05: i8  = 10_i32;
pub const  I8_06: i8  = 10_u32;
pub const  I8_07: i8  = 10_i64;
pub const  I8_08: i8  = 10_u64;
pub const  I8_09: i8  = 10;

pub const  U8_01: u8  = 10_i8;
pub const  U8_02: u8  = 10_u8;
pub const  U8_03: u8  = 10_i16;
pub const  U8_04: u8  = 10_u16;
pub const  U8_05: u8  = 10_i32;
pub const  U8_06: u8  = 10_u32;
pub const  U8_07: u8  = 10_i64;
pub const  U8_08: u8  = 10_u64;
pub const  U8_09: u8  = 10;

pub const I16_01: i16 = 10_i8;
pub const I16_02: i16 = 10_u8;
pub const I16_03: i16 = 10_i16;
pub const I16_04: i16 = 10_u16;
pub const I16_05: i16 = 10_i32;
pub const I16_06: i16 = 10_u32;
pub const I16_07: i16 = 10_i64;
pub const I16_08: i16 = 10_u64;
pub const I16_09: i16 = 10;

pub const U16_01: u16 = 10_i8;
pub const U16_02: u16 = 10_u8;
pub const U16_03: u16 = 10_i16;
pub const U16_04: u16 = 10_u16;
pub const U16_05: u16 = 10_i32;
pub const U16_06: u16 = 10_u32;
pub const U16_07: u16 = 10_i64;
pub const U16_08: u16 = 10_u64;
pub const U16_09: u16 = 10;

pub const I32_01: i32 = 10_i8;
pub const I32_02: i32 = 10_u8;
pub const I32_03: i32 = 10_i16;
pub const I32_04: i32 = 10_u16;
pub const I32_05: i32 = 10_i32;
pub const I32_06: i32 = 10_u32;
pub const I32_07: i32 = 10_i64;
pub const I32_08: i32 = 10_u64;
pub const I32_09: i32 = 10;

pub const U32_01: u32 = 10_i8;
pub const U32_02: u32 = 10_u8;
pub const U32_03: u32 = 10_i16;
pub const U32_04: u32 = 10_u16;
pub const U32_05: u32 = 10_i32;
pub const U32_06: u32 = 10_u32;
pub const U32_07: u32 = 10_i64;
pub const U32_08: u32 = 10_u64;
pub const U32_09: u32 = 10;

pub const I64_01: i64 = 10_i8;
pub const I64_02: i64 = 10_u8;
pub const I64_03: i64 = 10_i16;
pub const I64_04: i64 = 10_u16;
pub const I64_05: i64 = 10_i32;
pub const I64_06: i64 = 10_u32;
pub const I64_07: i64 = 10_i64;
pub const I64_08: i64 = 10_u64;
pub const I64_09: i64 = 10;

pub const U64_01: u64 = 10_i8;
pub const U64_02: u64 = 10_u8;
pub const U64_03: u64 = 10_i16;
pub const U64_04: u64 = 10_u16;
pub const U64_05: u64 = 10_i32;
pub const U64_06: u64 = 10_u32;
pub const U64_07: u64 = 10_i64;
pub const U64_08: u64 = 10_u64;
pub const U64_09: u64 = 10;

#[multiversx_sc::contract]
pub trait Empty {
    #[init]
    fn init(&self) {
    }

    #[upgrade]
    fn upgrade(&self) {}

}

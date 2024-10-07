#![no_std]

pub trait Second {
    fn f(&self, value: u64) -> u64 {
        value + 3_u64
    }
}

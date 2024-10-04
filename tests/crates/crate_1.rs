#![no_std]

use crate_2::*;

pub trait First {
    fn call_second(&self, second: ::crate_2::Second, value: u64) -> u64 {
        second.f(value)
    }
}

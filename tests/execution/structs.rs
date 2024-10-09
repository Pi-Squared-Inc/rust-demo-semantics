#![no_std]

#[allow(unused_imports)]
use multiversx_sc::imports::*;

struct Pair{i: u32, j: u32 }
struct Triple{i: u32, j: u32, k: u32 }

#[multiversx_sc::contract]
pub trait StructFile {
    #[init]
    fn init(&self) {
    }

    #[upgrade]
    fn upgrade(&self) {}

    fn struct_with_var_assignment(&self) -> u32 {
        let _pair = ::structs::Pair {
            i: 1_u32,
            j: 2_u32
        };
        let x = _pair.j;
        x
    }

    fn struct_without_var_assignment(&self) -> u32 {
        let _triple = ::structs::Triple {
            1_u32,
            2_u32,
            3_u32
        };
        let x = _triple.k;
        x
    }
}

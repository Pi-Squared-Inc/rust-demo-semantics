#![no_std]

#[allow(unused_imports)]
use multiversx_sc::imports::*;

#[multiversx_sc::contract]
pub trait IntegerOperations {
    #[init]
    fn init(&self) {
    }

    #[upgrade]
    fn upgrade(&self) {}

    fn arithmetic_expression_mult_constant(&self) -> u64 { 24_u64 * 60_u64 * 60_u64 }

    fn arithmetic_expression_div_constant(&self) -> u64 { 10_u64 / 4_u64 }

    fn arithmetic_expression_sum_constant(&self) -> u64 { 100_u64 + 1_u64 }

    fn arithmetic_expression_sub_constant(&self) -> u64 { 100_u64 - 1_u64  }

    fn arithmetic_expression_mod_constant(&self) -> u64 { 5_u64 % 3_u64 }

    fn relational_expression_equals(&self) -> bool { 5_u64 == 5_u64 }

    fn relational_expression_diff(&self) -> bool { 5_i64 != 5_i64 }

    fn relational_expression_smaller_or_equal(&self) -> bool { 5 >= 5 }

    fn relational_expression_greater_or_equal(&self) -> bool { 70 >= 7 }

    fn relational_expression_smaller(&self) -> bool { 5_u32 < 7_u32 }

    fn relational_expression_greater(&self) -> bool { 5_i32 > 7_i32 }

}

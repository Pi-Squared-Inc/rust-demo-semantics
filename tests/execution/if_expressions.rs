#![no_std]

#[allow(unused_imports)]
use multiversx_sc::imports::*;

#[multiversx_sc::contract]
pub trait IfExpressions {
    #[init]
    fn init(&self) {
    }

    #[upgrade]
    fn upgrade(&self) {}

    fn if_expression(&self) -> u64 {

        if 80_u64 == 80_u64 {
            1_u64
        }



    }

    fn if_else_expression(&self) -> u64 {

        if 80_u64 != 80_u64 {
            1_u64
        } else {
            2_u64
        }

    }

    fn if_else_if_expression(&self) -> u64 {

        if 80_u64 != 80_u64 {
            1_u64
        } else if false {
            2_u64
        } else {
            3_u64
        }

    }

    fn test_if_instruction(&self) -> u64 {
        if true {
          let x = 10_u64;
        } else {
          let y = 11_u64;
        };
        11_u64
      }

      fn test_if_no_return(&self) {
        if true {
            let x = 10_u64;
        } else {
            let y = 11_u64;
        };
      }

}

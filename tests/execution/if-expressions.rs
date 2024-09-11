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
    
    fn if_expression(&self) -> bool { 
        let x = 80_u64;
    
        if (x > 80_u64){
            return true;
        }
         else {
            return false;
        };

    }

}

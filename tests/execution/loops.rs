#![no_std]

#[allow(unused_imports)]
use multiversx_sc::imports::*;

#[multiversx_sc::contract]
pub trait LoopExpressions {
    #[init]
    fn init(&self) {
    }

    #[upgrade]
    fn upgrade(&self) {}
    
    fn iterator_evaluation(&self){ 

      for i | i in 1_u64..10_u64 {
        let x = i * 2_u64;
      };

    }

    fn while_evaluation(&self){ 

      while 1_u64 < 1_u64 {
        let x: u64 = 2_u64; 
      };
      
    }

    fn iterator_with_variables(&self) -> u64{ 
      let y = 20_u64;
      let z = 10_u64; 

      for i in z..y {
        let x = i * 2_u64;
      };

      x
    }

}

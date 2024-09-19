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

      // while 1_u64 < 1_u64 {
      //   let x: u64 = 2_u64; 
      // };

      // let i = 30_u64;
      // let j = i + 1_u64;

      for i in 1_u64..10_u64 {
        let x = 1_u64;
      };

    }

    fn while_evaluation(&self){ 

      while 1_u64 < 1_u64 {
        let x: u64 = 2_u64; 
      };
      
    }

}

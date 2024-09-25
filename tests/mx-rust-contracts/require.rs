#![no_std]

#[allow(unused_imports)]
use multiversx_sc::imports::*;

#[multiversx_sc::contract]
pub trait RequireContract {
    #[view(noArg)]
    #[storage_mapper("my_value")]
    fn my_storage(&self) -> SingleValueMapper<BigUint>;

    #[init]
    fn init(&self) {
        self.my_storage().set_if_empty(BigUint::from(10))
    }

    #[upgrade]
    fn upgrade(&self) {}

    #[endpoint(callRequirePassesRetv)]
    fn call_require_passes_retv(&self) -> u64 {
        require!(5_u64 > 4_u64, "Require failure");
        3_u64
    }

    #[endpoint(callRequireFailsRetv)]
    fn call_require_fails_retv(&self) -> u64 {
        require!(5_u64 > 6_u64, "Require failure");
        3_u64
    }

    #[endpoint(callRequirePassesInstr)]
    fn call_require_passes_Instr(&self) {
        require!(5_u64 > 4_u64, "Require failure");
        3_u64;
    }

    #[endpoint(callRequireFailsInstr)]
    fn call_require_fails_instr(&self) -> u64 {
        require!(5_u64 > 6_u64, "Require failure");
        3_u64;
    }

    #[endpoint(callRequireFailsUndoRetv)]
    fn call_require_fails_undo_retv(&self) {
        self.my_storage().set(BigUint::from(100_u64));
        require!(5_u64 > 6_u64, "Require failure");
        self.my_storage().set(BigUint::from(100_u64))
    }

    #[endpoint(callRequireFailsUndoInstr)]
    fn call_require_fails_undo_instr(&self) -> u64 {
        self.my_storage().set(BigUint::from(100_u64));
        require!(5_u64 > 6_u64, "Require failure");
        self.my_storage().set(BigUint::from(100_u64));
    }

    #[endpoint(getMyStorage)]
    fn get_my_storage(&self) -> BigUint {
        self.my_storage().get()
    }
}

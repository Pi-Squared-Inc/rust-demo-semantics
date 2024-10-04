#![no_std]

#[allow(unused_imports)]
use multiversx_sc::imports::*;

#[multiversx_sc::contract]
pub trait BoolOperations {
    #[init]
    fn init(&self) {
    }

    #[upgrade]
    fn upgrade(&self) {}

    fn bool_logical_operation_and(&self) -> bool { true && true }

    fn bool_logical_operation_or(&self) -> bool { false || true }

    fn bool_logical_operation_not(&self) -> bool {  ! true }

}

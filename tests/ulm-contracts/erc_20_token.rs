// This contract is a translation of
// https://github.com/Pi-Squared-Inc/pi2-examples/blob/b63d0a78922874a486be8a0395a627425fb5a052/solidity/src/tokens/SomeToken.sol
//
// The main change is that the contract does not issue specific error objects
// (e.g. ERC20InsufficientBalance), it just calls `::helpers::require` with various
// (string) explanations.
//
// Also, the `totalSupply` endpoint is declared implicitely as a view for
// `s_total_supply`.

#![no_std]

#[allow(unused_imports)]
use ulm::*;

#[ulm::contract]
pub trait Erc20Token {
    #[storage_mapper("total_supply")]
    fn s_total_supply(&self) -> ::single_value_mapper::SingleValueMapper<u256>;

    #[storage_mapper("balances")]
    fn s_balances(&self, address: u160) -> ::single_value_mapper::SingleValueMapper<u256>;

    #[storage_mapper("balances")]
    fn s_allowances(&self, account: u160, spender: u160) -> ::single_value_mapper::SingleValueMapper<u256>;

    #[init]
    fn init(&self) {
        let x = 0_u64;
    }

    #[upgrade]
    fn upgrade(&self) {}

    #[view(decimals)]
    fn decimals(&self) -> u8 {
        18
    }

    // #[view(totalSupply)]
    // fn total_supply(&self) -> u256 {
    //     self.s_total_supply().get()
    // }

    #[view(balanceOf)]
    fn balance_of(&self, account: u160) -> u256 {
        self.s_balances(account).get()
    }

    #[endpoint(transfer)]
    fn transfer(&self, to: u160, value: u256) -> bool {
        let owner = ::ulm::Caller();
        self._transfer(&owner, to, &value);
        true
    }

    // #[view(allowance)]
    // fn allowance(&self, owner: u160, spender: u160) -> u256 {
    //     self.s_allowances(owner, spender).get()
    // }

    #[endpoint(approve)]
    fn approve(&self, spender: u160, value: u256) -> bool {
        let owner = ::ulm::Caller();
        self._approve(&owner, spender, value, true);
        true
    }

    #[endpoint(transferFrom)]
    fn transfer_from(&self, from: u160, to: u160, value: u256) -> bool {
        let spender = ::ulm::Caller();
        self._spend_allowance(from, &spender, value);
        self._transfer(from, to, value);
        true
    }

    fn _transfer(&self, from: u160, to: u160, value: u256) {
        ::helpers::require(!::address::is_zero(from), "Invalid sender");
        ::helpers::require(!::address::is_zero(to), "Invalid receiver");
        self._update(from, to, value);
    }

    fn _update(&self, from: u160, to: u160, value: u256) {
        if ::address::is_zero(from) {
            self.s_total_supply().set(self.s_total_supply().get() + value);
        } else {
            let from_balance = self.s_balances(from).get();
            ::helpers::require(value <= &from_balance, "Insufficient balance");
            self.s_balances(from).set(self.s_balances(from).get() - value);
        };

        if ::address::is_zero(to) {
            self.s_total_supply().set(self.s_total_supply().get() - value);
        } else {
            self.s_balances(to).set(self.s_balances(to).get() + value);
        }
    }

    #[endpoint(mint)]
    fn mint(&self, account: u160, value: u256) {
        ::helpers::require(!::address::is_zero(account), "Zero address");
        self._update(0_u160, account, value);
    }

    fn _approve(&self, owner: u160, spender: u160, value: u256, emit_event: bool) {
        ::helpers::require(!::address::is_zero(owner), "Invalid approver");
        ::helpers::require(!::address::is_zero(spender), "Invalid spender");
        self.s_allowances(owner, spender).set(value);
    }

    fn _spend_allowance(&self, owner: u160, spender: u160, value: u256) {
        let current_allowance = self.allowance(owner, spender);
        ::helpers::require(value <= &current_allowance, "Insuficient allowance");
        self._approve(owner, spender, &(current_allowance - value), false);
    }

}

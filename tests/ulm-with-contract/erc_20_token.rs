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

/* ----------------------------------------------------------------------------

TODOs:
    - Integers are all u64 at the moment. Implement u256 and modify appropriately;
    - Reuse the implementation of ManagedBuffer for strings, and the annotations for
      the contract trait identification, as well as views, storage mappers, update, and
      inits;
    - Support some sort of struct for implementing MessageResult within the ULM module.
      We also have to figure out the contents of MessageResult.

Observations:
    - ManagedAddress was replaced by an integer to fit the behaviors of ULM;

---------------------------------------------------------------------------- */

#[ulm::contract]
pub trait Erc20Token {
    // #[view(totalSupply)]
    #[storage_mapper("total_supply")]
    fn s_total_supply(&self) -> ::single_value_mapper::SingleValueMapper<u256>;

    // #[view(getName)]
    #[storage_mapper("name")]
    fn s_name(&self) -> ::single_value_mapper::SingleValueMapper<ManagedBuffer>;

    // #[view(getSymbol)]
    #[storage_mapper("symbol")]
    fn s_symbol(&self) -> ::single_value_mapper::SingleValueMapper<ManagedBuffer>;

    // #[view(getBalances)]
    #[storage_mapper("balances")]
    fn s_balances(&self, address: u160) -> ::single_value_mapper::SingleValueMapper<u256>;

    // #[view(getAllowances)]
    #[storage_mapper("allowances")]
    fn s_allowances(&self, account: u160, spender: u160) -> ::single_value_mapper::SingleValueMapper<u256>;

    #[event("Transfer")]
    fn transfer_event(&self, #[indexed] from: u160, #[indexed] to: u160, value: u256);

    #[event("Approval")]
    fn approval_event(&self, #[indexed] owner: u160, #[indexed] spender: u160, value: u256);


    #[init]
    fn init(&self, /*name: &ManagedBuffer, symbol: &ManagedBuffer, */init_supply: u256) {
        // self.s_name().set_if_empty(name);
        // self.s_symbol().set_if_empty(symbol);
        self._mint(::ulm::Caller(), init_supply);
    }

    #[upgrade]
    fn upgrade(&self) {}

    #[view(decimals)]
    fn decimals(&self) -> u8 {
        18
    }

    #[view(totalSupply)]
    fn total_supply(&self) -> u256 {
        self.s_total_supply().get()
    }

    // #[view(name)]
    // fn name(&self) -> ManagedBuffer {
    //     self.s_name().get()
    // }

    // #[view(symbol)]
    // fn symbol(&self) -> ManagedBuffer {
    //     self.s_symbol().get()
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

    #[view(allowance)]
    fn allowance(&self, owner: u160, spender: u160) -> u256 {
        self.s_allowances(owner, spender).get()
    }

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
        self.transfer_event(from, to, value);
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

    fn _mint(&self, account: u160, value: u256) {
        ::helpers::require(!::address::is_zero(account), "Zero address");
        self._update(0_u160, account, value);
    }

    fn _approve(&self, owner: u160, spender: u160, value: u256, emit_event: bool) {
        ::helpers::require(!::address::is_zero(owner), "Invalid approver");
        ::helpers::require(!::address::is_zero(spender), "Invalid spender");
        self.s_allowances(owner, spender).set(value);
        if emit_event {
            self.approval_event(owner, spender, value);
        }
    }

    fn _spend_allowance(&self, owner: u160, spender: u160, value: u256) {
        let current_allowance = self.allowance(owner, spender);
        ::helpers::require(value <= &current_allowance, "Insuficient allowance");
        self._approve(owner, spender, &(current_allowance - value), false);
    }

}

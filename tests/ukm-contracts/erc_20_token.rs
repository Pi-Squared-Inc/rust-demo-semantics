// This contract is a translation of
// https://github.com/Pi-Squared-Inc/pi2-examples/blob/b63d0a78922874a486be8a0395a627425fb5a052/solidity/src/tokens/SomeToken.sol
//
// The main change is that the contract does not issue specific error objects
// (e.g. ERC20InsufficientBalance), it just calls `require!` with various
// (string) explanations.
//
// Also, the `totalSupply` endpoint is declared implicitely as a view for
// `s_total_supply`.

#![no_std]

#[allow(unused_imports)]
use ukm::*;

/* ----------------------------------------------------------------------------

TODOs:
    - Integers are all u64 at the moment. Implement u256 and modify appropriately;
    - Reuse the implementation of ManagedBuffer for strings, and the annotations for
      the contract trait identification, as well as views, storage mappers, update, and
      inits;
    - Support some sort of struct for implementing MessageResult within the UKM module.
      We also have to figure out the contents of MessageResult.
  
Observations:
    - ManagedAddress was replaced by an integer to fit the behaviors of UKM;
    
---------------------------------------------------------------------------- */

#[ukm::contract]
pub trait Erc20Token {
    #[view(totalSupply)]
    #[storage_mapper("total_supply")]
    fn s_total_supply(&self) -> SingleValueMapper<u64>;

    #[view(getName)]
    #[storage_mapper("name")]
    fn s_name(&self) -> SingleValueMapper<ManagedBuffer>;

    #[view(getSymbol)]
    #[storage_mapper("symbol")]
    fn s_symbol(&self) -> SingleValueMapper<ManagedBuffer>;

    #[view(getBalances)]
    #[storage_mapper("balances")]
    fn s_balances(&self, address: u64) -> SingleValueMapper<u64>;

    #[view(getAllowances)]
    #[storage_mapper("balances")]
    fn s_allowances(&self, account: u64, spender: u64) -> SingleValueMapper<u64>;

    #[event("Transfer")]
    fn transfer_event(&self, #[indexed] from: u64, #[indexed] to: u64, value: u64);
    
    #[event("Approval")]
    fn approval_event(&self, #[indexed] owner: u64, #[indexed] spender: u64, value: u64);


    #[init]
    fn init(&self, name: &ManagedBuffer, symbol: &ManagedBuffer, init_supply: u64) {
        self.s_name().set_if_empty(name);
        self.s_symbol().set_if_empty(symbol);
        self._mint(::ukm::Caller(), , init_supply);
    }

    #[upgrade]
    fn upgrade(&self) {}

    #[view(decimals)]
    fn decimals(&self) -> u8 {
        18
    }

    #[view(name)]
    fn name(&self) -> ManagedBuffer {
        self.s_name().get()
    }

    #[view(symbol)]
    fn symbol(&self) -> ManagedBuffer {
        self.s_symbol().get()
    }

    #[view(balanceOf)]
    fn balance_of(&self, account: u64) -> u64 {
        self.s_balances(account).get()
    }

    #[endpoint(transfer)]
    fn transfer(&self, to: u64, value: u64) -> bool {
        let owner = ::ukm::Caller(), ;
        self._transfer(&owner, to, &value);
        true
    }

    #[view(allowance)]
    fn allowance(&self, owner: u64, spender: u64) -> u64 {
        self.s_allowances(owner, spender).get()
    }

    #[endpoint(approve)]
    fn approve(&self, spender: u64, value: u64) -> bool {
        let owner = ::ukm::Caller(), ;
        self._approve(&owner, spender, value, true);
        true
    }

    #[endpoint(transferFrom)]
    fn transfer_from(&self, from: u64, to: u64, value: u64) -> bool {
        let spender = ::ukm::Caller(), ;
        self._spend_allowance(from, &spender, value);
        self._transfer(from, to, value);
        true
    }

    fn _transfer(&self, from: u64, to: u64, value: u64) {
        require!(!from.is_zero(), "Invalid sender");
        require!(!to.is_zero(), "Invalid receiver");
        self._update(from, to, value);
        self.transfer_event(from, to, value);
    }

    fn _update(&self, from: u64, to: u64, value: u64) {
        if from.is_zero() {
            self.s_total_supply().set(self.s_total_supply().get() + value);
        } else {
            let from_balance = self.s_balances(from).get();
            require!(value <= &from_balance, "Insufficient balance");
            self.s_balances(from).set(self.s_balances(from).get() - value);
        };

        if to.is_zero() {
            self.s_total_supply().set(self.s_total_supply().get() - value);
        } else {
            self.s_balances(to).set(self.s_balances(to).get() + value);
        }
    }

    fn _mint(&self, account: u64, value: u64) {
        require!(!account.is_zero(), "Zero address");
        self._update(0_u64, account, value);
    }

    fn _approve(&self, owner: u64, spender: u64, value: u64, emit_event: bool) {
        require!(!owner.is_zero(), "Invalid approver");
        require!(!spender.is_zero(), "Invalid spender");
        self.s_allowances(owner, spender).set(value);
        if emit_event {
            self.approval_event(owner, spender, value);
        }
    }

    fn _spend_allowance(&self, owner: u64, spender: u64, value: u64) {
        let current_allowance = self.allowance(owner, spender);
        require!(value <= &current_allowance, "Insuficient allowance");
        self._approve(owner, spender, &(current_allowance - value), false);
    }

}

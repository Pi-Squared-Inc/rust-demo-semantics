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
use multiversx_sc::imports::*;

#[multiversx_sc::contract]
pub trait Erc20Token {
    #[view(totalSupply)]
    #[storage_mapper("total_supply")]
    fn s_total_supply(&self) -> SingleValueMapper<BigUint>;

    #[view(getName)]
    #[storage_mapper("name")]
    fn s_name(&self) -> SingleValueMapper<ManagedBuffer>;

    #[view(getSymbol)]
    #[storage_mapper("symbol")]
    fn s_symbol(&self) -> SingleValueMapper<ManagedBuffer>;

    #[view(getBalances)]
    #[storage_mapper("balances")]
    fn s_balances(&self, address: &ManagedAddress) -> SingleValueMapper<BigUint>;

    #[view(getAllowances)]
    #[storage_mapper("allowances")]
    fn s_allowances(&self, account: &ManagedAddress, spender: &ManagedAddress) -> SingleValueMapper<BigUint>;

    #[event("Transfer")]
    fn transfer_event(&self, #[indexed] from: &ManagedAddress, #[indexed] to: &ManagedAddress, value: &BigUint);
    #[event("Approval")]
    fn approval_event(&self, #[indexed] owner: &ManagedAddress, #[indexed] spender: &ManagedAddress, value: &BigUint);


    #[init]
    fn init(&self, name: &ManagedBuffer, symbol: &ManagedBuffer, init_supply: &BigUint) {
        self.s_name().set_if_empty(name);
        self.s_symbol().set_if_empty(symbol);
        self._mint(&self.blockchain().get_caller(), init_supply);
    }

    #[upgrade]
    fn upgrade(&self) {}

    #[view(decimals)]
    fn decimals(&self) -> u8 {
        18_u8
    }

    // Already declared above
    // #[view(totalSupply)]
    // fn total_supply(&self) -> BigUint {
    //     self.s_total_supply().get()
    // }

    #[view(name)]
    fn name(&self) -> ManagedBuffer {
        self.s_name().get()
    }

    #[view(symbol)]
    fn symbol(&self) -> ManagedBuffer {
        self.s_symbol().get()
    }

    #[view(balanceOf)]
    fn balance_of(&self, account: &ManagedAddress) -> BigUint {
        self.s_balances(account).get()
    }

    #[endpoint(transfer)]
    fn transfer(&self, to: &ManagedAddress, value: BigUint) -> bool {
        let owner = self.blockchain().get_caller();
        self._transfer(&owner, to, &value);
        true
    }

    #[view(allowance)]
    fn allowance(&self, owner: &ManagedAddress, spender: &ManagedAddress) -> BigUint {
        self.s_allowances(owner, spender).get()
    }

    #[endpoint(approve)]
    fn approve(&self, spender: &ManagedAddress, value: &BigUint) -> bool {
        let owner = self.blockchain().get_caller();
        self._approve(&owner, spender, value, true);
        true
    }

    #[endpoint(transferFrom)]
    fn transfer_from(&self, from: &ManagedAddress, to: &ManagedAddress, value: &BigUint) -> bool {
        let spender = self.blockchain().get_caller();
        self._spend_allowance(from, &spender, value);
        self._transfer(from, to, value);
        true
    }

    fn _transfer(&self, from: &ManagedAddress, to: &ManagedAddress, value: &BigUint) {
        require!(!from.is_zero(), "Invalid sender");
        require!(!to.is_zero(), "Invalid receiver");
        self._update(from, to, value);
        self.transfer_event(from, to, value);
    }

    fn _update(&self, from: &ManagedAddress, to: &ManagedAddress, value: &BigUint) {
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

    fn _mint(&self, account: &ManagedAddress, value: &BigUint) {
        require!(!account.is_zero(), "Zero address");
        self._update(&ManagedAddress::zero(), account, value);
    }

    fn _approve(&self, owner: &ManagedAddress, spender: &ManagedAddress, value: &BigUint, emit_event: bool) {
        require!(!owner.is_zero(), "Invalid approver");
        require!(!spender.is_zero(), "Invalid spender");
        self.s_allowances(owner, spender).set(value);
        if emit_event {
            self.approval_event(owner, spender, value);
        }
    }

    fn _spend_allowance(&self, owner: &ManagedAddress, spender: &ManagedAddress, value: &BigUint) {
        let current_allowance = self.allowance(owner, spender);
        require!(value <= &current_allowance, "Insuficient allowance");
        self._approve(owner, spender, &(current_allowance - value), false);
    }

}

// This contract is a translation of https://github.com/Pi-Squared-Inc/solidity-demo-semantics/blob/f1204ebfed3b3c133735efe5186bcc02cf288074/test/demo-contracts/UniswapV2SwapRenamed.DAI.sol

// The main differences are
// - we include an init method
// - we do not include events emission

#![no_std]

#[allow(unused_imports)]
use ulm::*;

#[ulm::contract]
pub trait DAIMock {
    #[storage_mapper("total_supply")]
    fn s_total_supply(&self) -> ::single_value_mapper::SingleValueMapper<u256>;

    #[storage_mapper("balances")]
    fn s_balances(&self, address: u160) -> ::single_value_mapper::SingleValueMapper<u256>;

    #[storage_mapper("balances")]
    fn s_allowances(&self, account: u160, spender: u160) -> ::single_value_mapper::SingleValueMapper<u256>;

    #[view(totalSupply)]
    fn total_supply(&self) -> u256 {
        self.s_total_supply().get()
    }

    #[view(balanceOf)]
    fn balance_of(&self, account: u160) -> u256 {
        self.s_balances(account).get()
    }

    #[view(allowance)]
    fn allowance(&self, owner: u160, spender: u160) -> u256 {
        self.s_allowances(owner, spender).get()
    }

   #[init]
   fn init(&self) {
   }

    #[view(decimals)]
    fn decimals(&self) -> u8 {
        18
    }

    #[endpoint(mint)]
    fn mint(&self, account: u160, value: u256) {
        self.s_balances(account).set(self.s_balances(account).get() + value);
        self.s_total_supply().set(self.s_total_supply().get() + value);
    }

    #[endpoint(mintOnDeposit)]
    fn mintOnDeposit(&self, account: u160, value: u256) {
        self.mint(account, value);
    }

    #[endpoint(burn)]
    fn burn(&self, account: u160, value: u256) {
        if self.s_balances(account).get() >= value {
            self.s_balances(account).set(self.s_balances(account).get() - value);
            self.s_total_supply().set(self.s_total_supply().get() - value);
        }
    }

    #[endpoint(approve)]
    fn approve(&self, spender: u160, value: u256) -> bool {
        let owner = ::ulm::Caller();
        self.s_allowances(owner, spender).set(value);
        true
    }

    #[endpoint(transfer)]
    fn transfer(&self, to: u160, value: u256) -> bool {
        let owner = ::ulm::Caller();
        self.transferFrom(&owner, to, &value)
    }

    #[endpoint(transferFrom)]
    fn transferFrom(&self, from: u160, to: u160, value: u256) -> bool {
        ::helpers::require(self.s_balances(from).get() >= value, "Dai/insufficient-balance");
        let spender = ::ulm::Caller();
        if from != spender && self.s_allowances(from, spender).get() != 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff_u256 {
            ::helpers::require(self.s_allowances(from, spender).get() >= value, "Dai/insufficient-allowance");
            self.s_allowances(from, spender).set(self.s_allowances(from, spender).get() - value);
        };
        self.s_balances(from).set(self.s_balances(from).get() - value);
        self.s_balances(to).set(self.s_balances(to).get() + value);
        true
    }

    #[endpoint(safeTransferFrom)]
    fn safeTransferFrom(&self, from: u160, to: u160, value: u256) -> bool {
        self.transferFrom(from, to, &value);
    }

}

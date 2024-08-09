// This contract is a translation of UniswapV2Swap in
// https://github.com/Pi-Squared-Inc/pi2-examples/blob/fed5482baee62b60a080b1d426ffb10db463831e/solidity/src/swaps/UniswapV2Swap.sol
//
// Changes:
// * Initializaion does not add the router's pairs, they must be initialized
//   and added separately.
// * Various things related to the fact that contracts do not make transfers on
//   behalf of users and must receive the tokens with the call.
#![no_std]

#[allow(unused_imports)]
use multiversx_sc::imports::*;

mod router_proxy {
    multiversx_sc::imports!();

    #[multiversx_sc::proxy]
    pub trait UniswapV2RouterProxy {
        #[payable("*")]
        #[endpoint(swapExactTokensForTokens)]
        fn swap_exact_tokens_for_tokens(
            &self,
            amount_out_min: BigUint,
            to: &ManagedAddress,
            path: MultiValueEncoded<TokenIdentifier>,
        ) -> MultiValueEncoded<BigUint>;

        #[payable("*")]
        #[endpoint(swapTokensForExactTokens)]
        fn swap_tokens_for_exact_tokens(
            &self,
            amount_out: BigUint,
            to: &ManagedAddress,
            path: MultiValueEncoded<TokenIdentifier>,
        ) -> MultiValueEncoded<BigUint>;
    }
}


#[multiversx_sc::contract]
pub trait UniswapV2Swap {
    #[view(getWeth)]
    #[storage_mapper("weth")]
    fn weth(&self) -> SingleValueMapper<TokenIdentifier>;

    #[view(getDai)]
    #[storage_mapper("dai")]
    fn dai(&self) -> SingleValueMapper<TokenIdentifier>;

    #[view(getUsdc)]
    #[storage_mapper("usdc")]
    fn usdc(&self) -> SingleValueMapper<TokenIdentifier>;

    #[view(getRouter)]
    #[storage_mapper("router")]
    fn router(&self) -> SingleValueMapper<ManagedAddress>;

    #[init]
    fn init(&self, weth: &TokenIdentifier, dai: &TokenIdentifier, usdc: &TokenIdentifier, router: &ManagedAddress) {
        self.weth().set_if_empty(weth);
        self.dai().set_if_empty(dai);
        self.usdc().set_if_empty(usdc);

        self.router().set_if_empty(router);
    }

    #[upgrade]
    fn upgrade(&self) {}


    #[payable("*")]
    #[endpoint(swapExactTokensForTokens)]
    fn swap_single_hop_exact_amount_in(&self, amount_out_min: &BigUint) -> BigUint {
        let (token_in_id, amount_in) = self.call_value().single_fungible_esdt();
        require!(BigUint::zero() < amount_in, "Expected non-zero amount");
        require!(token_in_id == self.weth().get(), "Expecting weth transfer");

        let mut path: ManagedVec<TokenIdentifier> = ManagedVec::new();
        path.push(self.weth().get());
        path.push(self.dai().get());

        let path_encoded: MultiValueEncoded<TokenIdentifier> = path.into();
        let amounts: MultiValueEncoded<BigUint> = self.router_proxy(self.router().get())
                .swap_exact_tokens_for_tokens(amount_out_min, self.blockchain().get_caller(), path_encoded)
                .esdt((token_in_id, 0, amount_in))
                .execute_on_dest_context();
        let amounts_vec = amounts.to_vec();

        amounts_vec.get(1).clone_value()
    }

    #[payable("*")]
    #[endpoint(swapMultiHopExactAmountIn)]
    fn swap_multi_hop_exact_amount_in(&self, amount_out_min: &BigUint) -> BigUint {
        let (token_in_id, amount_in) = self.call_value().single_fungible_esdt();
        require!(BigUint::zero() < amount_in, "Expected non-zero amount");
        require!(token_in_id == self.dai().get(), "Expecting dai transfer");

        let mut path: ManagedVec<TokenIdentifier> = ManagedVec::new();
        path.push(self.dai().get());
        path.push(self.weth().get());
        path.push(self.usdc().get());

        let path_encoded: MultiValueEncoded<TokenIdentifier> = path.into();
        let amounts: MultiValueEncoded<BigUint> = self.router_proxy(self.router().get())
                .swap_exact_tokens_for_tokens(amount_out_min, self.blockchain().get_caller(), path_encoded)
                .esdt((token_in_id, 0, amount_in))
                .execute_on_dest_context();
        let amounts_vec = amounts.to_vec();

        amounts_vec.get(2).clone_value()
    }

    #[payable("*")]
    #[endpoint(swapSingleHopExactAmountOut)]
    fn swap_single_hop_exact_amount_out(&self, amount_out_desired: &BigUint) -> BigUint {
        let (token_in_id, amount_in) = self.call_value().single_fungible_esdt();
        require!(BigUint::zero() < amount_in, "Expected non-zero amount");
        require!(token_in_id == self.weth().get(), "Expecting weth transfer");

        let mut path: ManagedVec<TokenIdentifier> = ManagedVec::new();
        path.push(self.weth().get());
        path.push(self.dai().get());

        let path_encoded: MultiValueEncoded<TokenIdentifier> = path.into();
        let amounts: MultiValueEncoded<BigUint> = self.router_proxy(self.router().get())
                .swap_tokens_for_exact_tokens(amount_out_desired, self.blockchain().get_caller(), path_encoded)
                .esdt((token_in_id.clone(), 0, amount_in.clone()))
                .execute_on_dest_context();
        let amounts_vec = amounts.to_vec();

        let amount_used = amounts_vec.get(0).clone_value();
        if amount_used < amount_in {
            self.send().direct_esdt(
                &self.blockchain().get_caller(), &token_in_id, 0, &(amount_in - &amount_used)
            );
        };

        amounts_vec.get(1).clone_value()
    }

    #[payable("*")]
    #[endpoint(swapMultiHopExactAmountOut)]
    fn swap_multi_hop_exact_amount_out(
        &self, amount_out_desired: &BigUint
    ) -> BigUint {
        let (token_in_id, amount_in) = self.call_value().single_fungible_esdt();
        require!(BigUint::zero() < amount_in, "Expected non-zero amount");
        require!(token_in_id == self.dai().get(), "Expecting dai transfer");

        let mut path: ManagedVec<TokenIdentifier> = ManagedVec::new();
        path.push(self.dai().get());
        path.push(self.weth().get());
        path.push(self.usdc().get());

        let path_encoded: MultiValueEncoded<TokenIdentifier> = path.into();
        let amounts: MultiValueEncoded<BigUint> = self.router_proxy(self.router().get())
                .swap_tokens_for_exact_tokens(amount_out_desired, self.blockchain().get_caller(), path_encoded)
                .esdt((token_in_id.clone(), 0, amount_in.clone()))
                .execute_on_dest_context();
        let amounts_vec = amounts.to_vec();

        let amount_used = amounts_vec.get(0).clone_value();
        if amount_used < amount_in {
            self.send().direct_esdt(
                &self.blockchain().get_caller(), &token_in_id, 0, &(amount_in - &amount_used)
            );
        };

        amounts_vec.get(2).clone_value()
    }


    #[proxy]
    fn router_proxy(&self, sc_address: ManagedAddress) -> router_proxy::Proxy<Self::Api>;

}

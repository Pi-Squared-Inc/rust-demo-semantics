// The hooks in this module can be called by the semantics.
// Currently the semantics is required to keep track of the gas costs for these
// operations. This will change in the final version after October.
module ULM-HOOKS
  imports private BASIC-K
  imports private BOOL
  imports private INT
  imports private BYTES

  // block parameters
  syntax Int ::= GasLimit() [function, hook(ULM.gasLimit)]
               | BaseFee() [function, hook(ULM.baseFee)]
               | Coinbase() [function, hook(ULM.coinbase)]
               | BlockTimestamp() [function, hook(ULM.timestamp)]
               | BlockNumber() [function, hook(ULM.number)]
               | BlockDifficulty() [function, hook(ULM.difficulty)]
               | PrevRandao() [function, hook(ULM.prevRandao)]
  syntax Int ::= BlockHash(index: Int) [function, hook(ULM.blockHash), total]

  // transaction parameters
  syntax Int ::= GasPrice() [function, hook(ULM.gasPrice)]
               | Origin() [function, hook(ULM.origin)]

  // message parameters
  syntax Int ::= Address() [function, hook(ULM.address)]
               | Caller() [function, hook(ULM.caller)]
               | CallValue() [function, hook(ULM.callValue)]
  syntax Bytes ::= CallData() [function, hook(ULM.callData)]

  // chain parameters
  syntax Int ::= ChainId() [function, hook(ULM.chainId)]

  // account getters
  syntax Int ::= GetAccountBalance(acct: Int) [function, hook(ULM.getBalance), total]
  syntax Bytes ::= GetAccountCode(acct: Int) [function, hook(ULM.getCode), total]
  syntax Int ::= GetAccountStorage(key: Int) [function, hook(ULM.getStorage), total]
               | GetAccountOrigStorage(key: Int) [function, hook(ULM.getOrigStorage), total]
               | GetAccountTransientStorage(key: Int) [function, hook(ULM.getTransientStorage), total]
  syntax Bool ::= IsAccountEmpty(acct: Int) [function, hook(ULM.isAccountEmpty), total]

  // to be removed in final version
  syntax Bool ::= AccessedStorage(key: Int) [function, hook(ULM.accessedStorage), total]
  syntax Bool ::= AccessedAccount(acct: Int) [function, hook(ULM.accessedAccount), total]

  // account modifiers
  syntax Bool ::= Transfer(to: Int, value: Int) [function, hook(ULM.transfer), impure]
  syntax K ::= SelfDestruct(to: Int) [function, hook(ULM.selfdestruct), impure]
  syntax K ::= SetAccountStorage(key: Int, value: Int) [function, hook(ULM.setStorage)]
             | SetAccountTransientStorage(key: Int, value: Int) [function, hook(ULM.setTransientStorage)]

  // log emitters
  syntax K ::= Log0(data: Bytes) [function, hook(ULM.log0)]
             | Log1(topic0: Int, data: Bytes) [function, hook(ULM.log1)]
             | Log2(topic0: Int, topic1: Int, data: Bytes) [function, hook(ULM.log2)]
             | Log3(topic0: Int, topic1: Int, topic2: Int, data: Bytes) [function, hook(ULM.log3)]
             | Log4(topic0: Int, topic1: Int, topic2: Int, topic3: Int, data: Bytes) [function, hook(ULM.log4)]

  syntax Int ::= "EVMC_REJECTED" [function]
               | "EVMC_INTERNAL_ERROR" [function]
               | "EVMC_SUCCESS" [function]
               | "EVMC_REVERT" [function]
               | "EVMC_FAILURE" [function]
               | "EVMC_INVALID_INSTRUCTION" [function]
               | "EVMC_UNDEFINED_INSTRUCTION" [function]
               | "EVMC_OUT_OF_GAS" [function] 
               | "EVMC_BAD_JUMP_DESTINATION" [function]
               | "EVMC_STACK_OVERFLOW" [function]
               | "EVMC_STACK_UNDERFLOW" [function]
               | "EVMC_CALL_DEPTH_EXCEEDED" [function]
               | "EVMC_INVALID_MEMORY_ACCESS" [function]
               | "EVMC_STATIC_MODE_VIOLATION" [function]
               | "EVMC_PRECOMPILE_FAILURE" [function]
               | "EVMC_NONCE_EXCEEDED" [function]

  rule EVMC_REJECTED => 0
  rule EVMC_INTERNAL_ERROR => 1
  rule EVMC_SUCCESS => 2
  rule EVMC_REVERT => 3
  rule EVMC_FAILURE => 4
  rule EVMC_INVALID_INSTRUCTION => 5
  rule EVMC_UNDEFINED_INSTRUCTION => 6
  rule EVMC_OUT_OF_GAS => 7
  rule EVMC_BAD_JUMP_DESTINATION => 8
  rule EVMC_STACK_OVERFLOW => 9
  rule EVMC_STACK_UNDERFLOW => 10
  rule EVMC_CALL_DEPTH_EXCEEDED => 11
  rule EVMC_INVALID_MEMORY_ACCESS => 12
  rule EVMC_STATIC_MODE_VIOLATION => 13
  rule EVMC_PRECOMPILE_FAILURE => 14
  rule EVMC_NONCE_EXCEEDED => 15

  // external account calls and creation
  syntax MessageResult ::= MessageResult(gas: Int, data: Bytes, status: Int, target: Int) [symbol(MessageResult)]
                         | Create(value: Int, data: Bytes, gas: Int) [function, hook(ULM.create), impure]
                         | Create2(value: Int, data: Bytes, salt: Bytes, gas: Int) [function, hook(ULM.create2), impure]
                         | Call(gas: Int, to: Int, value: Int, data: Bytes) [function, hook(ULM.call), impure]
                         | CallCode(gas: Int, to: Int, value: Int, data: Bytes) [function, hook(ULM.callCode), impure]
                         | DelegateCall(gas: Int, to: Int, data: Bytes) [function, hook(ULM.delegateCall), impure]
                         | StaticCall(gas: Int, to: Int, data: Bytes) [function, hook(ULM.staticCall), impure]

endmodule

// The functions in this module must be implemented by the semantics. They
// represent the way the integration layer understands the output of the call
// frame (i.e., return data buffer, status code, gas remaining)
module ULM-SIGNATURE
  imports ULM-HOOKS
  imports private BYTES
  imports private INT

  syntax GeneratedTopCell

  syntax Bytes ::= getOutput(GeneratedTopCell) [function, symbol(getOutput), total]
  rule getOutput(_) => .Bytes [owise]

  syntax Int ::= getStatus(GeneratedTopCell) [function, symbol(getStatus), total]
  rule getStatus(_) => EVMC_INTERNAL_ERROR [owise]

  syntax Int ::= getGasLeft(GeneratedTopCell) [function, symbol(getGasLeft), total]
  rule getGasLeft(_) => 0 [owise]

endmodule

module ULM
  imports ULM-SIGNATURE

  // Additionally, the semantics must declare the following configuration
  // variables only. It is allowed for some of these variables to be ommitted
  // if the semantics does not need them.
  //
  // $PGM:Bytes - This is the value of the contract's code as stored by the
  // StateDB. The semantics is responsible for deserializing this into a
  // format it is able to execute.
  //
  // $ACCTCODE:Int - This is the 160-bit integer address of the account that
  // corresponds to the $PGM.
  //
  // $SCHEDULE:Int - This is the value of the schedule_t from ulm_kllvm.h that
  // corresponds to the EVM execution layer hard fork active on the current
  // block. It can be ignored for non-EVM semantics; a different mechanism for
  // handling layer upgrades will likely be developed post-October.
  //
  // $GAS:Int - This is the amount of gas provided to the contract. Eventually
  // gas calculations will be handled a different way instead of being tracked
  // by the semantics. For now nothing prevents a semantics from ignoring this
  // value, which leaves the chain open to denial-of-service attacks.
  //
  // $STATIC:Bool - This indicates whether the current contract is allowed
  // to modify the block state. Currently this is not enforced; nothing stops
  // the semantics from choosing to ignore it. This will change in the final
  // version.
  //
  // $CREATE:Bool - This indicates whether this is a contract creation message.
  // Non-EVM languages may need this information to decide how to decode the
  // $PGM variable
endmodule

```k

module ULM-SEMANTICS-HOOKS-ULM-SYNTAX
    imports INT-SYNTAX

    syntax UlmHook  ::= CallDataHook()
                      | CallerHook()
                      | SetAccountStorageHook(Int, Int)
                      | GetAccountStorageHook(Int)

    syntax K
    syntax Type
    syntax UlmHookResult  ::= ulmNoResult()
                            | ulmIntResult(Int, Type)
endmodule


module ULM-SEMANTICS-HOOKS-ULM
    imports private RUST-REPRESENTATION
    imports private RUST-SHARED-SYNTAX
    imports private ULM-SEMANTICS-HOOKS-SIGNATURE
    imports private ULM-SEMANTICS-HOOKS-ULM-SYNTAX
    imports private ULM-REPRESENTATION

    syntax Identifier ::= "ulm"  [token]
                        | "CallData"  [token]
                        | "Caller"  [token]
                        | "SetAccountStorage"  [token]
                        | "GetAccountStorage"  [token]

    rule normalizedFunctionCall ( :: ulm :: CallData :: .PathExprSegments , .PtrList )
        => CallDataHook()
    rule normalizedFunctionCall ( :: ulm :: Caller :: .PathExprSegments , .PtrList )
        => CallerHook()

    rule normalizedFunctionCall
            ( :: ulm :: SetAccountStorage :: .PathExprSegments
            , (KeyPtr:Ptr , ValuePtr:Ptr , .PtrList)
            )
        => #SetAccountStorageHook
            ( ulmCast(KeyPtr, ptrValue(null, rustType(u256)))
            , ulmCast(ValuePtr, ptrValue(null, rustType(u256)))
            )

    syntax UlmHook ::= #SetAccountStorageHook(Expression, Expression)  [seqstrict]

    rule #SetAccountStorageHook(ptrValue(_, u256(Key)), ptrValue(_, u256(Value)))
        => SetAccountStorageHook(MInt2Unsigned(Key), MInt2Unsigned(Value))

    rule normalizedFunctionCall
            ( :: ulm :: GetAccountStorage :: .PathExprSegments
            , (KeyPtr:Ptr , .PtrList)
            )
        => #GetAccountStorageHook(ulmCast(KeyPtr, ptrValue(null, rustType(u256))))

    syntax UlmHook ::= #GetAccountStorageHook(Expression)  [strict]

    rule #GetAccountStorageHook(ptrValue(_, u256(Key)))
        => GetAccountStorageHook(MInt2Unsigned(Key))

    rule ulmNoResult() => ptrValue(null, tuple(.ValueList))
    rule ulmIntResult(Value:Int, T:Type) => ulmValueResult(integerToValue(Value, T))

    syntax UlmHook ::= ulmValueResult(ValueOrError)
    rule ulmValueResult(V:Value) => ptrValue(null, V)

endmodule

// This module should be used only in kompilation targets which have implementations
// for the ULM hooks.
module ULM-SEMANTICS-HOOKS-TO-ULM-FUNCTIONS
    imports private RUST-REPRESENTATION
    imports private ULM-SEMANTICS-HOOKS-ULM-SYNTAX
    imports private ULM-HOOKS
    imports private ULM-REPRESENTATION

    rule CallDataHook() => ulmBytesNew(CallData())
    rule CallerHook() => ulmIntResult(Caller(), u160)
    rule SetAccountStorageHook(Key:Int, Value:Int) => SetAccountStorage(Key, Value) ~> ulmNoResult()
    rule GetAccountStorageHook(Key:Int) => ulmIntResult(GetAccountStorage(Key), u256)
endmodule

module ULM-SEMANTICS-HOOKS-SIGNATURE
    imports private ULM-SIGNATURE
    imports private ULM-SEMANTICS-HOOKS-STATE-CONFIGURATION
    imports private ULM-TARGET-CONFIGURATION

    rule getOutput
            (   <generatedTop>
                    <ulm>
                        <ulm-state>
                            <ulm-output> Value:Bytes </ulm-output>
                            ...
                        </ulm-state>
                        ...
                    </ulm>
                    ...
                </generatedTop>
            )
        => Value

    rule getStatus
            (   <generatedTop>
                    <ulm>
                        <ulm-state>
                            <ulm-status> Value:Int </ulm-status>
                            ...
                        </ulm-state>
                        ...
                    </ulm>
                    ...
                </generatedTop>
            )
        => Value

    rule getGasLeft
            (   <generatedTop>
                    <ulm>
                        <ulm-state>
                            <ulm-gas> Value:Int </ulm-gas>
                            ...
                        </ulm-state>
                        ...
                    </ulm>
                    ...
                </generatedTop>
            )
        => Value

endmodule

```

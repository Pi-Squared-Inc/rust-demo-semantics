```k

module UKM-HOOKS-UKM-SYNTAX
    imports INT-SYNTAX

    syntax UkmHook  ::= CallDataHook()
                      | CallerHook()
                      | SetAccountStorageHook(Int, Int)
                      | GetAccountStorageHook(Int)

    syntax K
    syntax Type
    syntax UkmHookResult  ::= ukmNoResult()
                            | ukmIntResult(Int, Type)
endmodule


module UKM-HOOKS-UKM
    imports private RUST-REPRESENTATION
    imports private RUST-SHARED-SYNTAX
    imports private UKM-HOOKS-SIGNATURE
    imports private UKM-HOOKS-UKM-SYNTAX
    imports private UKM-REPRESENTATION

    syntax Identifier ::= "ukm"  [token]
                        | "CallData"  [token]
                        | "Caller"  [token]
                        | "SetAccountStorage"  [token]
                        | "GetAccountStorage"  [token]

    rule normalizedFunctionCall ( :: ukm :: CallData :: .PathExprSegments , .PtrList )
        => CallDataHook()
    rule normalizedFunctionCall ( :: ukm :: Caller :: .PathExprSegments , .PtrList )
        => CallerHook()

    rule normalizedFunctionCall
            ( :: ukm :: SetAccountStorage :: .PathExprSegments
            , (KeyPtr:Ptr , ValuePtr:Ptr , .PtrList)
            )
        => #SetAccountStorageHook(KeyPtr, ValuePtr)

    syntax UkmHook ::= #SetAccountStorageHook(Expression, Expression)  [seqstrict]

    rule #SetAccountStorageHook(ptrValue(_, u64(Key)), ptrValue(_, u64(Value)))
        => SetAccountStorageHook(MInt2Unsigned(Key), MInt2Unsigned(Value))

    rule normalizedFunctionCall
            ( :: ukm :: GetAccountStorage :: .PathExprSegments
            , (KeyPtr:Ptr , .PtrList)
            )
        => #GetAccountStorageHook(KeyPtr)

    syntax UkmHook ::= #GetAccountStorageHook(Expression)  [strict]

    rule #GetAccountStorageHook(ptrValue(_, u64(Key)))
        => GetAccountStorageHook(MInt2Unsigned(Key))

    rule ukmNoResult() => ptrValue(null, tuple(.ValueList))
    rule ukmIntResult(Value:Int, T:Type) => ukmValueResult(integerToValue(Value, T))

    syntax UkmHook ::= ukmValueResult(ValueOrError)
    rule ukmValueResult(V:Value) => ptrValue(null, V)

endmodule

// This module should be used only in kompilation targets which have implementations
// for the ULM hooks.
module UKM-HOOKS-TO-ULM-FUNCTIONS
    imports private RUST-REPRESENTATION
    imports private UKM-HOOKS-UKM-SYNTAX
    imports private ULM-HOOKS
    imports private UKM-REPRESENTATION

    rule CallDataHook() => ukmBytesNew(CallData())
    rule CallerHook() => ukmIntResult(Caller(), u160)
    rule SetAccountStorageHook(Key:Int, Value:Int) => SetAccountStorage(Key, Value) ~> ukmNoResult()
    rule GetAccountStorageHook(Key:Int) => ukmIntResult(GetAccountStorage(Key), u256)
endmodule

module UKM-HOOKS-SIGNATURE
    imports private ULM-SIGNATURE
    imports private UKM-HOOKS-STATE-CONFIGURATION
    imports private UKM-TARGET-CONFIGURATION

    rule getOutput
            (   <generatedTop>
                    <ukm>
                        <ukm-state>
                            <ukm-output> Value:Bytes </ukm-output>
                            ...
                        </ukm-state>
                        ...
                    </ukm>
                    ...
                </generatedTop>
            )
        => Value

    rule getStatus
            (   <generatedTop>
                    <ukm>
                        <ukm-state>
                            <ukm-status> Value:Int </ukm-status>
                            ...
                        </ukm-state>
                        ...
                    </ukm>
                    ...
                </generatedTop>
            )
        => Value

    rule getGasLeft
            (   <generatedTop>
                    <ukm>
                        <ukm-state>
                            <ukm-gas> Value:Int </ukm-gas>
                            ...
                        </ukm-state>
                        ...
                    </ukm>
                    ...
                </generatedTop>
            )
        => Value

endmodule

```

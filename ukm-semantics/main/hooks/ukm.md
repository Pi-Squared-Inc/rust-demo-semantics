```k

module UKM-HOOKS-UKM-SYNTAX
    imports INT-SYNTAX

    syntax UkmHook  ::= CallDataHook()
                      | CallerHook()
                      | SetAccountStorageHook(Int, Int)
                      | GetAccountStorageHook(Int)

    syntax UkmHookResult  ::= ukmNoResult()
                            | ukmInt64Result(Int)
endmodule


module UKM-HOOKS-UKM
    imports private RUST-REPRESENTATION
    imports private RUST-SHARED-SYNTAX
    imports private UKM-HOOKS-UKM-SYNTAX

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
    syntax UkmHook ::= #ukmInt64Result(ValueOrError)
    rule ukmInt64Result(Value:Int) => #ukmInt64Result(integerToValue(Value, u64))
    rule #ukmInt64Result(V:Value) => ptrValue(null, V)

endmodule

```

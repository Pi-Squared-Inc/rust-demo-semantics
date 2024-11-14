```k

module ULM-SEMANTICS-HOOKS-ULM-SYNTAX
    imports INT-SYNTAX
    imports BYTES-SYNTAX

    syntax UlmHook  ::= CallDataHook()
                      | CallerHook()
                      | SetAccountStorageHook(Int, Int)
                      | GetAccountStorageHook(Int)
                      // TODO: Build mocks for all the hooks below in a meaningful
                      // way in tests (right now we just use opaque values).
                      | Log0Hook(Bytes)
                      | Log1Hook(Int, Bytes)
                      | Log2Hook(Int, Int, Bytes)
                      | Log3Hook(Int, Int, Int, Bytes)
                      | Log4Hook(Int, Int, Int, Int, Bytes)

    syntax K
    syntax Type
    syntax UlmHookResult  ::= ulmNoResult()
                            | ulmIntResult(Int, Type)
endmodule


module ULM-SEMANTICS-HOOKS-ULM
    imports private RUST-REPRESENTATION
    imports private RUST-SHARED-SYNTAX
    imports private ULM-HOOKS
    imports private ULM-SEMANTICS-HOOKS-SIGNATURE
    imports private ULM-SEMANTICS-HOOKS-ULM-SYNTAX
    imports private ULM-REPRESENTATION

    syntax Identifier ::= "ulm"  [token]
                        | "CallData"  [token]
                        | "Caller"  [token]
                        | "SetAccountStorage"  [token]
                        | "GetAccountStorage"  [token]
                        | "Log0"  [token]
                        | "Log1"  [token]
                        | "Log2"  [token]
                        | "Log3"  [token]
                        | "Log4"  [token]

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


    rule normalizedFunctionCall
            ( :: ulm :: Log0 :: .PathExprSegments
            , (BytesPtr:Ptr , .PtrList)
            )
        => #Log0Hook(BytesPtr)

    syntax UlmHook ::=  #Log0Hook(Expression)  [strict]
                      | #Log0Hook(UlmExpression)  [strict]

    rule #Log0Hook(ptrValue(_, u64(BytesId)))
        => #Log0Hook(ulmBytesId(BytesId))
    rule #Log0Hook(ulmBytesValue(B:Bytes)) => Log0Hook(B)


    rule normalizedFunctionCall
            ( :: ulm :: Log1 :: .PathExprSegments
            , (V0:Ptr, BytesPtr:Ptr , .PtrList)
            )
        => #Log1Hook(ulmCast(V0, ptrValue(null, rustType(u256))), BytesPtr)

    syntax UlmHook ::=  #Log1Hook(Expression, Expression)  [seqstrict]
                      | #Log1Hook(Int, UlmExpression)  [strict(2)]

    rule #Log1Hook(ptrValue(_, u256(V0)), ptrValue(_, u64(BytesId)))
        => #Log1Hook(MInt2Unsigned(V0), ulmBytesId(BytesId))
    rule #Log1Hook(V0:Int, ulmBytesValue(B:Bytes)) => Log1Hook(V0, B)


    rule normalizedFunctionCall
            ( :: ulm :: Log2 :: .PathExprSegments
            , (V0:Ptr, V1:Ptr, BytesPtr:Ptr , .PtrList)
            )
        => #Log2Hook
                ( ulmCast(V0, ptrValue(null, rustType(u256)))
                , ulmCast(V1, ptrValue(null, rustType(u256)))
                , BytesPtr
                )

    syntax UlmHook ::=  #Log2Hook(Expression, Expression, Expression)  [seqstrict]
                      | #Log2Hook(Int, Int, UlmExpression)  [strict(3)]

    rule #Log2Hook
            ( ptrValue(_, u256(V0))
            , ptrValue(_, u256(V1))
            , ptrValue(_, u64(BytesId))
            )
        => #Log2Hook
            ( MInt2Unsigned(V0)
            , MInt2Unsigned(V1)
            , ulmBytesId(BytesId)
            )
    rule #Log2Hook(V0:Int, V1:Int, ulmBytesValue(B:Bytes)) => Log2Hook(V0, V1, B)


    rule normalizedFunctionCall
            ( :: ulm :: Log3 :: .PathExprSegments
            , (V0:Ptr, V1:Ptr, V2:Ptr, BytesPtr:Ptr , .PtrList)
            )
        => #Log3Hook
                ( ulmCast(V0, ptrValue(null, rustType(u256)))
                , ulmCast(V1, ptrValue(null, rustType(u256)))
                , ulmCast(V2, ptrValue(null, rustType(u256)))
                , BytesPtr
                )

    syntax UlmHook ::=  #Log3Hook(Expression, Expression, Expression, Expression)  [seqstrict]
                      | #Log3Hook(Int, Int, Int, UlmExpression)  [strict(4)]

    rule #Log3Hook
            ( ptrValue(_, u256(V0))
            , ptrValue(_, u256(V1))
            , ptrValue(_, u256(V2))
            , ptrValue(_, u64(BytesId))
            )
        => #Log3Hook
            ( MInt2Unsigned(V0)
            , MInt2Unsigned(V1)
            , MInt2Unsigned(V2)
            , ulmBytesId(BytesId)
            )
    rule #Log3Hook(V0:Int, V1:Int, V2:Int, ulmBytesValue(B:Bytes)) => Log3Hook(V0, V1, V2, B)


    rule normalizedFunctionCall
            ( :: ulm :: Log4 :: .PathExprSegments
            , (V0:Ptr, V1:Ptr, V2:Ptr, V3:Ptr, BytesPtr:Ptr , .PtrList)
            )
        => #Log4Hook
                ( ulmCast(V0, ptrValue(null, rustType(u256)))
                , ulmCast(V1, ptrValue(null, rustType(u256)))
                , ulmCast(V2, ptrValue(null, rustType(u256)))
                , ulmCast(V3, ptrValue(null, rustType(u256)))
                , BytesPtr
                )

    syntax UlmHook ::=  #Log4Hook(Expression, Expression, Expression, Expression, Expression)  [seqstrict]
                      | #Log4Hook(Int, Int, Int, Int, UlmExpression)  [strict(4)]

    rule #Log4Hook
            ( ptrValue(_, u256(V0))
            , ptrValue(_, u256(V1))
            , ptrValue(_, u256(V2))
            , ptrValue(_, u256(V4))
            , ptrValue(_, u64(BytesId))
            )
        => #Log4Hook
            ( MInt2Unsigned(V0)
            , MInt2Unsigned(V1)
            , MInt2Unsigned(V2)
            , MInt2Unsigned(V4)
            , ulmBytesId(BytesId)
            )
    rule #Log4Hook(V0:Int, V1:Int, V2:Int, V4:Int, ulmBytesValue(B:Bytes)) => Log4Hook(V0, V1, V2, V4, B)


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
    rule Log0Hook(V:Bytes) => Log0(V) ~> ulmNoResult()
    rule Log1Hook(V0:Int, V:Bytes) => Log1(V0, V) ~> ulmNoResult()
    rule Log2Hook(V0:Int, V1:Int, V:Bytes) => Log2(V0, V1, V) ~> ulmNoResult()
    rule Log3Hook(V0:Int, V1:Int, V2:Int, V:Bytes) => Log3(V0, V1, V2, V) ~> ulmNoResult()
    rule Log4Hook(V0:Int, V1:Int, V2:Int, V3:Int, V:Bytes) => Log4(V0, V1, V2, V3, V) ~> ulmNoResult()
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

```k

module MX-RUST-MODULES-BIGUINT
    imports private COMMON-K-CELL
    imports private MX-COMMON-SYNTAX
    imports private MX-RUST-BIGUINT-OPERATORS
    imports private MX-RUST-REPRESENTATION
    imports private RUST-EXECUTION-CONFIGURATION
    imports private RUST-REPRESENTATION
    imports private RUST-SHARED-SYNTAX

    syntax MxRustType ::= "MxRust#bigInt"

    rule
        <k>
            normalizedFunctionCall
                ( #token("BigUint", "Identifier"):Identifier
                    :: #token("from", "Identifier"):Identifier
                ,   ( ptr(ValueId:Int)
                    , .PtrList
                    )
                )
            // TODO: Should check that V >= 0
            => mxRustBigIntNew(valueToInteger(V))
            ...
        </k>
        <values> ValueId |-> V:Value ... </values>

    rule normalizedFunctionCall
            ( #token("BigUint", "Identifier"):Identifier
                :: #token("zero", "Identifier"):Identifier
            , .PtrList
            )
        => mxRustBigIntNew(0)

  // --------------------------------------
    rule bigUintFromValueType
        => rustStructType
            ( #token("BigUint", "Identifier"):Identifier
            ,   ( mxRustStructField
                    ( #token("mx_biguint_id", "Identifier"):Identifier
                    , MxRust#bigInt
                    )
                , .MxRustStructFields
                )
            )
    rule bigUintFromIdType
        => rustStructType
            ( #token("BigUint", "Identifier"):Identifier
            ,   ( mxRustStructField
                    ( #token("mx_biguint_id", "Identifier"):Identifier
                    , i32
                    )
                , .MxRustStructFields
                )
            )
  // --------------------------------------
    rule mxToRustTyped(#token("BigUint", "Identifier"):Identifier, V:MxValue)
        => mxToRustTyped(bigUintFromValueType, mxListValue(V))

    rule (.K => MX#bigIntNew(mxIntValue(I)))
        ~> mxToRustTyped(MxRust#bigInt, mxIntValue(I:Int))
    rule (mxIntValue(I:Int) ~> mxToRustTyped(MxRust#bigInt, mxIntValue(_:Int)))
        => mxToRustTyped(i32, mxIntValue(I:Int))
  // --------------------------------------

    syntax MxRustInstruction  ::= mxRustBigIntNew(IntOrError)
                                | "mxRustCreateBigUint"

    rule mxRustBigIntNew(V:Int)
        => mxToRustTyped(bigUintFromValueType, mxListValue(mxIntValue(V)))

    rule mxRustEmptyValue(rustType(#token("BigUint", "Identifier")))
        => mxRustBigIntNew(0)

    rule mxValueToRust(#token("BigUint", "Identifier"), mxIntValue(I:Int))
        => mxRustBigIntNew(I)

    rule
        rustToMx(struct (#token("BigUint", "Identifier"):Identifier, _) #as S)
        => rustValueToMx(S) ~> rustToMx

    rule rustValueToMx
            ( struct
                ( #token("BigUint", "Identifier"):Identifier
                , _:Map
                ) #as S:Value
            )
        => mxRustGetBigIntFromStruct(S)

    rule
        <k>
            mxRustGetBigIntFromStruct
                ( struct
                    ( #token("BigUint", "Identifier"):Identifier
                    , #token("mx_biguint_id", "Identifier"):Identifier |-> BigUintIdId:Int
                        _:Map
                    )
                )
            => mxGetBigInt(MInt2Unsigned(BigUintId))
            ...
        </k>
        <values>
            BigUintIdId |-> i32(BigUintId:MInt{32})
            ...
        </values>

endmodule

module MX-RUST-BIGUINT-OPERATORS
    imports private COMMON-K-CELL
    imports private MX-RUST-REPRESENTATION
    imports private RUST-EXECUTION-CONFIGURATION

    syntax MxRustInstruction ::= rustMxBinaryBigUintOperator(MxHookName, Value, Value)
    rule
        <k>
            rustMxBinaryBigUintOperator
                ( Hook:MxHookName
                , struct
                    ( #token("BigUint", "Identifier"):Identifier #as BigUint:TypePath
                    , #token("mx_biguint_id", "Identifier"):Identifier |-> FirstId:Int
                      _:Map
                    )
                , struct
                    ( #token("BigUint", "Identifier"):Identifier #as BigUint:TypePath
                    , #token("mx_biguint_id", "Identifier"):Identifier |-> SecondId:Int
                      _:Map
                    )
                )
            => rustMxCallHook(Hook, (V1, V2, .ValueList))
              ~> mxRustWrapInMxList
              ~> mxToRustTyped(bigUintFromIdType)
            ...
        </k>
        <values>
            FirstId |-> V1:Value
            SecondId |-> V2:Value
            ...
        </values>

    rule
        ptrValue(_, struct(#token("BigUint", "Identifier"):Identifier, _) #as V1:Value)
            + ptrValue(_, struct(#token("BigUint", "Identifier"):Identifier, _) #as V2:Value)
        => rustMxBinaryBigUintOperator(MX#bigIntAdd, V1, V2)

    rule
        ptrValue(_, struct(#token("BigUint", "Identifier"):Identifier, _) #as V1:Value)
            - ptrValue(_, struct(#token("BigUint", "Identifier"):Identifier, _) #as V2:Value)
        => rustMxBinaryBigUintOperator(MX#bigIntSub, V1, V2)

    rule
        ptrValue(_, struct(#token("BigUint", "Identifier"):Identifier, _) #as V1:Value)
            * ptrValue(_, struct(#token("BigUint", "Identifier"):Identifier, _) #as V2:Value)
        => rustMxBinaryBigUintOperator(MX#bigIntMul, V1, V2)

    rule
        ptrValue(_, struct(#token("BigUint", "Identifier"):Identifier, _) #as V1:Value)
            / ptrValue(_, struct(#token("BigUint", "Identifier"):Identifier, _) #as V2:Value)
        => rustMxBinaryBigUintOperator(MX#bigIntDiv, V1, V2)



    rule
        (ptrValue(_, struct(#token("BigUint", "Identifier"):Identifier, _)) #as V1:PtrValue)
            + (ptrValue(_, u64(_:MInt{64})) #as V2:PtrValue)
        => V1 + bigUintFrom(V2)

    rule
        (ptrValue(_, struct(#token("BigUint", "Identifier"):Identifier, _)) #as V1:PtrValue)
            - (ptrValue(_, u64(_:MInt{64})) #as V2:PtrValue)
        => V1 - bigUintFrom(V2)

    rule
        (ptrValue(_, struct(#token("BigUint", "Identifier"):Identifier, _)) #as V1:PtrValue)
            * (ptrValue(_, u64(_:MInt{64})) #as V2:PtrValue)
        => V1 * bigUintFrom(V2)

    rule
        (ptrValue(_, struct(#token("BigUint", "Identifier"):Identifier, _)) #as V1:PtrValue)
            / (ptrValue(_, u64(_:MInt{64})) #as V2:PtrValue)
        => V1 / bigUintFrom(V2)

    syntax Expression ::= bigUintFrom(Expression)  [function, total]
    rule bigUintFrom(V:Expression)
        =>  ( #token("BigUint", "Identifier"):Identifier
            :: #token("from", "Identifier"):Identifier
            :: .PathExprSegments
            )
            ( V, .CallParamsList )


    syntax MxRustInstruction ::= rustMxBinaryBigUintComparisonOperator(MxHookName, Value, Value)
    rule
        <k>
            rustMxBinaryBigUintComparisonOperator
                ( Hook:MxHookName
                , struct
                    ( #token("BigUint", "Identifier"):Identifier
                    , #token("mx_biguint_id", "Identifier"):Identifier |-> FirstId:Int
                      _:Map
                    )
                , struct
                    ( #token("BigUint", "Identifier"):Identifier
                    , #token("mx_biguint_id", "Identifier"):Identifier |-> SecondId:Int
                      _:Map
                    )
                )
            => rustMxCallHook(Hook, (V1, V2, .ValueList))
              ~> mxToRustTyped(i32)
            ...
        </k>
        <values>
            FirstId |-> V1:Value
            SecondId |-> V2:Value
            ...
        </values>

    rule
        ptrValue(_, struct(#token("BigUint", "Identifier"):Identifier, _) #as V1:Value)
            == ptrValue(_, struct(#token("BigUint", "Identifier"):Identifier, _) #as V2:Value)
        => rustMxBinaryBigUintComparisonOperator(MX#bigIntCmp, V1, V2)
            ~> mxRustEqResult
    rule
        ptrValue(_, struct(#token("BigUint", "Identifier"):Identifier, _) #as V1:Value)
            != ptrValue(_, struct(#token("BigUint", "Identifier"):Identifier, _) #as V2:Value)
        => rustMxBinaryBigUintComparisonOperator(MX#bigIntCmp, V1, V2)
            ~> mxRustNeResult
    rule
        ptrValue(_, struct(#token("BigUint", "Identifier"):Identifier, _) #as V1:Value)
            < ptrValue(_, struct(#token("BigUint", "Identifier"):Identifier, _) #as V2:Value)  // >
        => rustMxBinaryBigUintComparisonOperator(MX#bigIntCmp, V1, V2)
            ~> mxRustLtResult
    rule
        ptrValue(_, struct(#token("BigUint", "Identifier"):Identifier, _) #as V1:Value)
            <= ptrValue(_, struct(#token("BigUint", "Identifier"):Identifier, _) #as V2:Value)
        => rustMxBinaryBigUintComparisonOperator(MX#bigIntCmp, V1, V2)
            ~> mxRustLeResult
    rule
        ptrValue(_, struct(#token("BigUint", "Identifier"):Identifier, _) #as V1:Value)
            > ptrValue(_, struct(#token("BigUint", "Identifier"):Identifier, _) #as V2:Value)
        => rustMxBinaryBigUintComparisonOperator(MX#bigIntCmp, V1, V2)
            ~> mxRustGtResult
    rule
        ptrValue(_, struct(#token("BigUint", "Identifier"):Identifier, _) #as V1:Value)
            >= ptrValue(_, struct(#token("BigUint", "Identifier"):Identifier, _) #as V2:Value)
        => rustMxBinaryBigUintComparisonOperator(MX#bigIntCmp, V1, V2)
            ~> mxRustGeResult

    syntax MxRustInstruction  ::= "mxRustEqResult"
                                | "mxRustNeResult"
                                | "mxRustGeResult"
                                | "mxRustGtResult"
                                | "mxRustLeResult"
                                | "mxRustLtResult"

    rule V:PtrValue ~> mxRustEqResult => V == ptrValue(null, i32(0p32))
    rule V:PtrValue ~> mxRustNeResult => V != ptrValue(null, i32(0p32))
    rule V:PtrValue ~> mxRustGeResult => V >= ptrValue(null, i32(0p32))
    rule V:PtrValue ~> mxRustGtResult => V > ptrValue(null, i32(0p32))
    rule V:PtrValue ~> mxRustLtResult => V < ptrValue(null, i32(0p32))  // >
    rule V:PtrValue ~> mxRustLeResult => V <= ptrValue(null, i32(0p32))

endmodule

```

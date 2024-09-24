```k

module MX-RUST-MODULES-BIGUINT
    imports private COMMON-K-CELL
    imports private MX-COMMON-SYNTAX
    imports private MX-RUST-REPRESENTATION
    imports private RUST-EXECUTION-CONFIGURATION
    imports private RUST-REPRESENTATION
    imports private RUST-SHARED-SYNTAX

    syntax MxRustType ::= "MxRust#bigInt"
    
    rule
        <k>
            normalizedMethodCall
                ( #token("BigUint", "Identifier"):Identifier
                , #token("from", "Identifier"):Identifier
                ,   ( ptr(ValueId:Int)
                    , .PtrList
                    )
                )
            // TODO: Should check that V >= 0
            => mxRustBigIntNew(valueToInteger(V))
            ...
        </k>
        <values> ValueId |-> V:Value ... </values>

  // --------------------------------------
    syntax MxRustType ::= "bigUintType"  [function, total]
    rule bigUintType
        => rustStructType
            ( #token("BigUint", "Identifier"):Identifier
            ,   ( mxRustStructField
                    ( #token("mx_biguint_id", "Identifier"):Identifier
                    , MxRust#bigInt
                    )
                , .MxRustStructFields
                )
            )
  // --------------------------------------
    rule mxToRustTyped(#token("BigUint", "Identifier"):Identifier, V:MxValue)
        => mxToRustTyped(bigUintType, mxListValue(V))

    rule (.K => MX#bigIntNew(mxIntValue(I)))
        ~> mxToRustTyped(MxRust#bigInt, mxIntValue(I:Int))
    rule (mxIntValue(I:Int) ~> mxToRustTyped(MxRust#bigInt, mxIntValue(_:Int)))
        => mxToRustTyped(i32, mxIntValue(I:Int))
  // --------------------------------------

    syntax MxRustInstruction  ::= mxRustBigIntNew(IntOrError)
                                | "mxRustCreateBigUint"

    rule mxRustBigIntNew(V:Int)
        => mxToRustTyped(bigUintType, mxListValue(mxIntValue(V)))

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

```

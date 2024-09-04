```k

module MX-RUST-MODULES-BIGUINT
    imports private COMMON-K-CELL
    imports private MX-COMMON-SYNTAX
    imports private RUST-EXECUTION-CONFIGURATION
    imports private RUST-REPRESENTATION
    imports private RUST-SHARED-SYNTAX

    syntax MxRustInstruction  ::= mxRustBigIntNew(IntOrError)
                                | "mxRustCreateBigUint"

    rule
        <k>
            normalizedMethodCall
                ( #token("BigUint", "Identifier"):Identifier
                , #token("from", "Identifier"):Identifier
                ,   ( ptr(ValueId:Int)
                    , .NormalizedCallParams
                    )
                )
            => mxRustBigIntNew(valueToInteger(V))
            ...
        </k>
        <values> ValueId |-> V:Value ... </values>

  // --------------------------------------

    rule mxRustBigIntNew(V:Int)
        => MX#bigIntNew(mxIntValue(V))
            ~> mxValueToRust(i32)
            ~> mxRustCreateBigUint

    rule ptrValue(ptr(BigUintId:Int), _) ~> mxRustCreateBigUint
        => mxRustNewValue
            ( struct
                ( #token("BigUint", "Identifier"):Identifier
                , #token("mx_biguint_id", "Identifier"):Identifier |-> BigUintId
                )
            )

endmodule

```
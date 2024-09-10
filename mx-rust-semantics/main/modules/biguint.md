```k

module MX-RUST-MODULES-BIGUINT
    imports private COMMON-K-CELL
    imports private MX-COMMON-SYNTAX
    imports private MX-RUST-REPRESENTATION
    imports private RUST-EXECUTION-CONFIGURATION
    imports private RUST-REPRESENTATION
    imports private RUST-SHARED-SYNTAX

    rule
        <k>
            normalizedMethodCall
                ( #token("BigUint", "Identifier"):Identifier
                , #token("from", "Identifier"):Identifier
                ,   ( ptr(ValueId:Int)
                    , .NormalizedCallParams
                    )
                )
            // TODO: Should check that V >= 0
            => mxRustBigIntNew(valueToInteger(V))
            ...
        </k>
        <values> ValueId |-> V:Value ... </values>

  // --------------------------------------

    syntax MxRustInstruction  ::= mxRustBigIntNew(IntOrError)
                                | "mxRustCreateBigUint"

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

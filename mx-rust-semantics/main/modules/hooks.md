```k

module MX-RUST-MODULES-HOOKS
    imports private COMMON-K-CELL
    imports private MX-COMMON-SYNTAX
    imports private MX-RUST-REPRESENTATION
    imports private RUST-EXECUTION-CONFIGURATION
    imports private RUST-REPRESENTATION
    imports private RUST-SHARED-SYNTAX

    rule
        <k>
            normalizedMethodCall
                ( #token("MxRust#Hooks", "Identifier"):Identifier
                , #token("MxRust#loadMxReturnValue", "Identifier"):Identifier
                ,   ( ptr(ReturnTypeId:Int)
                    , .PtrList
                    )
                )
            => MX#popLastReturnValue(.MxValueList) ~> mxToRustTyped(T)
            ...
        </k>
        <values>
            ReturnTypeId |-> rustType(T)
            ...
        </values>

endmodule

```

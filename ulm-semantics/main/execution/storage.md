```k

module ULM-EXECUTION-STORAGE
    imports private RUST-REPRESENTATION
    imports private RUST-SHARED-SYNTAX
    imports private ULM-REPRESENTATION

    syntax Identifier ::= "get"  [token]
                        | "GetAccountStorage"  [token]
                        | "key"  [token]
                        | "set"  [token]
                        | "SetAccountStorage"  [token]
                        | "single_value_mapper"  [token]
                        | "SingleValueMapper"  [token]
                        | "ulm"  [token]

    rule normalizedFunctionCall
            ( :: single_value_mapper :: SingleValueMapper :: set :: .PathExprSegments
            , (SelfPtr:Ptr , ValuePtr:Ptr , .PtrList)
            )
        =>  :: ulm :: SetAccountStorage :: .PathExprSegments
            ( SelfPtr . key
            , ulmCast(ValuePtr, ptrValue(null, rustType(u64)))
            , .CallParamsList
            )

    rule normalizedFunctionCall
            ( :: single_value_mapper :: SingleValueMapper :: get :: .PathExprSegments
            , (SelfPtr:Ptr , .PtrList)
            )
        =>  :: ulm :: GetAccountStorage :: .PathExprSegments
            ( SelfPtr . key
            , .CallParamsList
            )

endmodule

```

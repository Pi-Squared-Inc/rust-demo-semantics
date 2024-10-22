```k

module UKM-EXECUTION-STORAGE
    imports private RUST-REPRESENTATION
    imports private RUST-SHARED-SYNTAX
    imports private UKM-REPRESENTATION

    syntax Identifier ::= "get"  [token]
                        | "GetAccountStorage"  [token]
                        | "key"  [token]
                        | "set"  [token]
                        | "SetAccountStorage"  [token]
                        | "single_value_mapper"  [token]
                        | "SingleValueMapper"  [token]
                        | "ukm"  [token]

    rule normalizedFunctionCall
            ( :: single_value_mapper :: SingleValueMapper :: set :: .PathExprSegments
            , (SelfPtr:Ptr , ValuePtr:Ptr , .PtrList)
            )
        =>  :: ukm :: SetAccountStorage :: .PathExprSegments
            ( SelfPtr . key
            , ukmCast(ValuePtr, ptrValue(null, rustType(u64)))
            , .CallParamsList
            )

    rule normalizedFunctionCall
            ( :: single_value_mapper :: SingleValueMapper :: get :: .PathExprSegments
            , (SelfPtr:Ptr , .PtrList)
            )
        =>  :: ukm :: GetAccountStorage :: .PathExprSegments
            ( SelfPtr . key
            , .CallParamsList
            )

endmodule

```

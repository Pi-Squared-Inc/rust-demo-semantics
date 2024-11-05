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
                        | "value_type"  [token]

    rule normalizedFunctionCall
            ( :: single_value_mapper :: SingleValueMapper :: set :: .PathExprSegments
            , (SelfPtr:Ptr , ValuePtr:Ptr , .PtrList)
            )
        =>  :: ulm :: SetAccountStorage :: .PathExprSegments
            ( SelfPtr . key
            , ulmCast(ValuePtr, SelfPtr . value_type)
            , .CallParamsList
            )

    rule normalizedFunctionCall
            ( :: single_value_mapper :: SingleValueMapper :: get :: .PathExprSegments
            , (SelfPtr:Ptr , .PtrList)
            )
        =>  ulmCast
                ( :: ulm :: GetAccountStorage :: .PathExprSegments
                    ( SelfPtr . key
                    , .CallParamsList
                    )
                , SelfPtr . value_type
                )

endmodule

```

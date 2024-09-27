```k

module MX-RUST-MODULES-TOKEN-IDENTIFIER
    imports private MX-COMMON-SYNTAX
    imports private MX-RUST-REPRESENTATION
    imports private MX-RUST-REPRESENTATION-CONVERSIONS
    imports private RUST-SHARED-SYNTAX

    syntax MxRustType ::= "tokenIdentifierType"  [function, total]
    rule tokenIdentifierType
        => rustStructType
            ( #token("TokenIdentifier", "Identifier"):Identifier
            ,   ( mxRustStructField
                    ( #token("mx_token_identifier", "Identifier"):Identifier
                    , str
                    )
                , .MxRustStructFields
                )
            )

    rule mxRustEmptyValue(rustType(#token("TokenIdentifier", "Identifier")))
        => mxToRustTyped(tokenIdentifierType, mxListValue(mxStringValue("")))

    rule mxValueToRust(#token("TokenIdentifier", "Identifier"), V:MxValue)
        => mxToRustTyped(tokenIdentifierType, mxListValue(V))

    rule rustValueToMx
            ( struct
                ( #token("TokenIdentifier", "Identifier"):Identifier
                , #token("mx_token_identifier", "Identifier"):Identifier |-> TokenValueId:Int
                  .Map
                )
            )
        => ptr(TokenValueId) ~> rustValueToMx

endmodule

```

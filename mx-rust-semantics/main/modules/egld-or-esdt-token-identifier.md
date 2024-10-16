```k

module MX-RUST-MODULES-EGLD-OR-ESDT-TOKEN-IDENTIFIER
    imports private MX-COMMON-SYNTAX
    imports private MX-RUST-REPRESENTATION
    imports private MX-RUST-REPRESENTATION-CONVERSIONS
    imports private RUST-SHARED-SYNTAX

    rule
        normalizedMethodCall
            ( #token("EgldOrEsdtTokenIdentifier", "Identifier"):Identifier
            , #token("from", "Identifier"):Identifier
            ,   ( ptr(ValueId:Int)
                , .PtrList
                )
            )
        // TODO: Should check that V >= 0
        => (
            let #token("x", "Identifier"):Identifier = newEgldOrEsdtTokenIdentifier();
            #token("x", "Identifier") . #token("mx_token_identifier", "Identifier")
                = ptr(ValueId) . #token("mx_token_identifier", "Identifier");
            #token("x", "Identifier"):Expression
        ):Statements

  // --------------------------------------

    syntax MxRustType ::= "egldOrEsdtTokenIdentifierType"  [function, total]
    rule egldOrEsdtTokenIdentifierType
        => rustStructType
            ( #token("EgldOrEsdtTokenIdentifier", "Identifier"):Identifier
            ,   ( mxRustStructField
                    ( #token("mx_token_identifier", "Identifier"):Identifier
                    , str
                    )
                , .MxRustStructFields
                )
            )

    rule mxRustEmptyValue(rustType(#token("EgldOrEsdtTokenIdentifier", "Identifier")))
        => mxToRustTyped(egldOrEsdtTokenIdentifierType, mxListValue(mxStringValue("")))

    rule mxValueToRust(#token("EgldOrEsdtTokenIdentifier", "Identifier"), V:MxValue)
        => mxToRustTyped(egldOrEsdtTokenIdentifierType, mxListValue(V))

    rule rustValueToMx
            ( struct
                ( #token("EgldOrEsdtTokenIdentifier", "Identifier"):Identifier
                , #token("mx_token_identifier", "Identifier"):Identifier |-> TokenValueId:Int
                  .Map
                )
            )
        => ptr(TokenValueId) ~> rustValueToMx

  // --------------------------------------

    syntax Expression ::= "newEgldOrEsdtTokenIdentifier"

    rule newEgldOrEsdtTokenIdentifier => mxRustEmptyValue(rustType(#token("EgldOrEsdtTokenIdentifier", "Identifier")))

endmodule

```

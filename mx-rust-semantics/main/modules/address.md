```k

module MX-RUST-MODULES-ADDRESS
    imports private MX-COMMON-SYNTAX
    imports private MX-RUST-REPRESENTATION
    imports private MX-RUST-REPRESENTATION-CONVERSIONS
    imports private RUST-SHARED-SYNTAX

    syntax MxRustType ::= "addressType"  [function, total]
    rule addressType
        => rustStructType
            ( #token("ManagedAddress", "Identifier"):Identifier
            ,   ( mxRustStructField
                    ( #token("mx_address_value", "Identifier"):Identifier
                    , str
                    )
                , .MxRustStructFields
                )
            )

    rule mxRustEmptyValue(rustType(#token("ManagedAddress", "Identifier")))
        => mxToRustTyped(addressType, mxListValue(mxStringValue("")))

    rule mxValueToRust(#token("ManagedAddress", "Identifier"), V:MxValue)
        => mxToRustTyped(addressType, mxListValue(V))

    rule rustValueToMx
            ( struct
                ( #token("ManagedAddress", "Identifier"):Identifier
                , #token("mx_address_value", "Identifier"):Identifier |-> AddressValueId:Int
                  .Map
                )
            )
        => ptr(AddressValueId) ~> rustValueToMx

endmodule

```

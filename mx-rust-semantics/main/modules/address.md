```k

module MX-RUST-MODULES-ADDRESS
    imports private MX-COMMON-SYNTAX
    imports private MX-RUST-REPRESENTATION
    imports private MX-RUST-REPRESENTATION-CONVERSIONS
    imports private RUST-SHARED-SYNTAX

    syntax Identifier ::= "ManagedAddress"  [token]
                        | "mx_address_value"  [token]

    rule
        normalizedMethodCall
            ( ManagedAddress
            , #token("zero", "Identifier"):Identifier
            , ( .PtrList)
            )
        => mxRustEmptyValue(rustType(ManagedAddress))

    rule
        normalizedMethodCall
            ( ManagedAddress
            , #token("is_zero", "Identifier"):Identifier
            , ( ptr(SelfId) , .PtrList)
            )
        => ptr(SelfId) . mx_address_value == ""

  // --------------------------------------

    syntax MxRustType ::= "addressType"  [function, total]
    rule addressType
        => rustStructType
            ( ManagedAddress
            ,   ( mxRustStructField
                    ( mx_address_value
                    , str
                    )
                , .MxRustStructFields
                )
            )

    rule mxRustEmptyValue(rustType(ManagedAddress))
        => mxToRustTyped(addressType, mxListValue(mxStringValue("")))

    rule mxValueToRust(ManagedAddress, V:MxValue)
        => mxToRustTyped(addressType, mxListValue(V))

    rule rustValueToMx
            ( struct
                ( ManagedAddress
                , mx_address_value |-> AddressValueId:Int
                  .Map
                )
            )
        => ptr(AddressValueId) ~> rustValueToMx

  // --------------------------------------

    rule toString(ptrValue(P:Ptr, struct(ManagedAddress, _:Map)))
        => toString(P .  #token("mx_address_value", "Identifier"))
endmodule

```

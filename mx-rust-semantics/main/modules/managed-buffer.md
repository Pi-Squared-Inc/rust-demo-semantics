```k

module MX-RUST-MODULES-MANAGED-BUFFER
    imports private MX-RUST-REPRESENTATION
    imports private RUST-SHARED-SYNTAX

  // --------------------------------------

    syntax MxRustType ::= "managedBufferType"  [function, total]
    rule managedBufferType
        => rustStructType
            ( #token("ManagedBuffer", "Identifier"):Identifier
            ,   ( mxRustStructField
                    ( #token("mx_buffer_id", "Identifier"):Identifier
                    , MxRust#buffer
                    )
                , .MxRustStructFields
                )
            )

    rule mxValueToRust
            ( #token("ManagedBuffer", "Identifier")
            , V:MxValue
            )
        => mxToRustTyped(managedBufferType, mxListValue(V , .MxValueList))

    rule rustValueToMx
            ( struct
                ( #token("ManagedBuffer", "Identifier"):Identifier
                , #token("mx_buffer_id", "Identifier"):Identifier |-> VecValueId:Int
                  .Map
                )
            )
        => mxRustGetBuffer(ptr(VecValueId))

  // --------------------------------------

endmodule

```

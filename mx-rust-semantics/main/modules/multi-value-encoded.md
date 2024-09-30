```k

module MX-RUST-MODULES-MULTI-VALUE-ENCODED
    imports private MX-RUST-REPRESENTATION
    imports private RUST-SHARED-SYNTAX

    syntax MxRustInstruction ::= toVec(Expression)  [strict]

    rule
        normalizedMethodCall
            ( #token("MultiValueEncoded", "Identifier"):Identifier
            , #token("to_vec", "Identifier"):Identifier
            , ( ptr(SelfId) , .PtrList)
            )
        => toVec(ptr(SelfId))

    rule toVec
            ( ptrValue
                ( _
                , struct
                    ( _
                    ,   ( #token("mx_buffer_id", "Identifier"):Identifier |-> _
                            #token("value_type", "Identifier"):Identifier |-> _
                            .Map
                        ) #as M:Map
                    )
                )
            )
        => ptrValue(null, struct(#token("ManagedVec", "Identifier"):Identifier , M))

  // --------------------------------------

    syntax MxRustType ::= "multiValueEncodedType"  [function, total]
    rule multiValueEncodedType
        => rustStructType
            ( #token("MultiValueEncoded", "Identifier"):Identifier
            ,   ( mxRustStructField
                    ( #token("mx_buffer_id", "Identifier"):Identifier
                    , MxRust#buffer
                    )
                , mxRustStructField
                    ( #token("value_type", "Identifier"):Identifier
                    , MxRust#Type
                    )
                , .MxRustStructFields
                )
            )

    rule mxValueToRust
            ( #token("MultiValueEncoded", "Identifier") < ValueType:Type , .GenericArgList >
            , V:MxValue
            )
        => mxToRustTyped(multiValueEncodedType, mxListValue(V , mxRustType(ValueType) , .MxValueList))

    rule rustValueToMx
            ( struct
                ( #token("MultiValueEncoded", "Identifier"):Identifier
                , #token("mx_buffer_id", "Identifier"):Identifier |-> VecValueId:Int
                  #token("value_type", "Identifier"):Identifier |-> _:Int
                  .Map
                )
            )
        => mxRustGetBuffer(ptr(VecValueId))

    syntax MxRustInstruction ::= mxRustGetBuffer(Expression)  [strict]
    rule mxRustGetBuffer(ptrValue(_, i32(BufferId:MInt{32})))
        => mxGetBuffer(MInt2Unsigned(BufferId))

  // --------------------------------------

endmodule

```

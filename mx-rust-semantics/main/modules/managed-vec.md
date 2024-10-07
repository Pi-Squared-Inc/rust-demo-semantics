```k

module MX-RUST-MODULES-MANAGED-VEC
    imports private COMMON-K-CELL
    imports private MX-COMMON-SYNTAX
    imports private MX-RUST-REPRESENTATION
    imports private MX-RUST-REPRESENTATION-CONVERSIONS
    imports private RUST-EXECUTION-CONFIGURATION
    imports private RUST-SHARED-SYNTAX

    rule
        normalizedFunctionCall
            ( #token("ManagedVec", "Identifier"):Identifier
                :: #token("new", "Identifier"):Identifier
            , .PtrList
            )
        => mxRustEmptyValue(rustType(#token("ManagedVec", "Identifier")))

    rule
        normalizedMethodCall
            ( #token("ManagedVec", "Identifier"):Identifier
            , #token("len", "Identifier"):Identifier
            , ( ptr(SelfId) , .PtrList)
            )
        => rustMxCallHookP
                ( MX#mBufferGetLength
                ,   ( ptr(SelfId) . #token("mx_buffer_id", "Identifier"):Identifier
                    , .CallParamsList
                    )
                )
            // TODO: This is actually usize.
            ~> mxToRustTyped(u64)

    rule
        normalizedMethodCall
            ( #token("ManagedVec", "Identifier"):Identifier
            , #token("push", "Identifier"):Identifier
            , ( ptr(SelfId) , ptr(ValueId) ,  .PtrList)
            )
        => rustMxCallHookP
                ( MX#mBufferAppend
                ,   ( ptr(SelfId) . #token("mx_buffer_id", "Identifier"):Identifier
                    , ptr(ValueId)
                    , .CallParamsList
                    )
                )
            ~> mxToRustTyped(i32)
            ~> clearValue
            ~> ptrValue(null, tuple(.ValueList))

    rule
        normalizedMethodCall
            ( #token("ManagedVec", "Identifier"):Identifier
            , #token("get", "Identifier"):Identifier
            , ( ptr(SelfId) , ptr(IndexId) ,  .PtrList)
            )
        => rustMxCallHookP
                ( MX#mBufferGetEntry
                ,   ( ptr(SelfId) . #token("mx_buffer_id", "Identifier"):Identifier
                    , ptr(IndexId)
                    , .CallParamsList
                    )
                )
            ~> mxToRustTypedExpression(ptr(SelfId) . #token("value_type", "Identifier"):Identifier)

    rule
        normalizedMethodCall
            ( #token("ManagedVec", "Identifier"):Identifier
            , #token("set", "Identifier"):Identifier
            , ( ptr(SelfId) , ptr(PositionId) , ptr(ValueId) ,  .PtrList)
            )
        => rustMxCallHookP
                ( MX#mBufferSetEntry
                ,   ( ptr(SelfId) . #token("mx_buffer_id", "Identifier"):Identifier
                    , ptr(PositionId)
                    , ptr(ValueId)
                    , .CallParamsList
                    )
                )
            ~> mxToRustTyped(i32)
            ~> clearValue
            ~> ptrValue(null, tuple(.ValueList))

    rule
        normalizedMethodCall
            ( #token("ManagedVec", "Identifier"):Identifier
            , #token("into", "Identifier"):Identifier
            , ( ptr(SelfId) , .PtrList)
            )
        => into(ptr(SelfId))

  // --------------------------------------

    syntax MxRustType ::= "managedVecType"  [function, total]
    rule managedVecType
        => rustStructType
            ( #token("ManagedVec", "Identifier"):Identifier
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

    rule mxRustEmptyValue(rustType(#token("ManagedVec", "Identifier")))
        => mxToRustTyped
            ( managedVecType
            , mxListValue(mxListValue(.MxValueList) , mxRustType(()) , .MxValueList)
            )

    rule mxValueToRust(#token("ManagedVec", "Identifier"), V:MxValue)
        => mxToRustTyped(managedVecType, mxListValue(V , mxRustType(()) , .MxValueList))

    rule rustValueToMx
            ( struct
                ( #token("ManagedVec", "Identifier"):Identifier
                , #token("mx_buffer_id", "Identifier"):Identifier |-> VecValueId:Int
                  #token("value_type", "Identifier"):Identifier |-> _:Int
                  .Map
                )
            )
        => ptr(VecValueId) ~> rustValueToMx

  // --------------------------------------

    // We don't infer types, so we have to fix the result type after creating
    // the ManagedVec
    rule
        <k>
            let mut Variable:Identifier
                : #token("ManagedVec", "Identifier") < T:Type , .GenericArgList  > #as FullType:Type
                = ptrValue
                    ( P:Ptr
                    , struct
                        ( _
                        , #token("value_type", "Identifier"):Identifier |-> TypeId:Int
                          _:Map
                        )
                    );
            =>
                P . #token("value_type", "Identifier"):Identifier = ptrValue(null, T);
                ~> let mut Variable : FullType = P;
            ...
        </k>
        <values>
            TypeId |-> ():Type
            ...
        </values>
        [priority(20), label(xyzzy)]

  // --------------------------------------

    syntax MxRustInstruction ::= into(Expression)  [strict]

    rule into
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
        => ptrValue(null, struct(#token("MultiValueEncoded", "Identifier"):Identifier , M))

endmodule

```

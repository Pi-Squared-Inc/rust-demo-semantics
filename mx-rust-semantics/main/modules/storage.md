```k

module MX-RUST-MODULES-STORAGE
    imports private COMMON-K-CELL
    imports private MX-COMMON-SYNTAX
    imports private MX-RUST-REPRESENTATION
    imports private RUST-EXECUTION-CONFIGURATION
    imports private RUST-REPRESENTATION
    imports private RUST-SHARED-SYNTAX

    rule
        normalizedFunctionCall
            ( #token("SingleValueMapper", "Identifier"):Identifier
              :: #token("new", "Identifier"):Identifier
            ,   ( ptr(KeyId:Int)
                , ptr(ResultTypeId:Int)
                , .PtrList
                )
            )
        => mxRustNewValue
            ( struct
                ( #token("SingleValueMapper", "Identifier"):Identifier
                , #token("storage_key", "Identifier"):Identifier |-> KeyId
                    #token("result_type", "Identifier"):Identifier |-> ResultTypeId
                )
            )

    rule
        <k>
            normalizedMethodCall
                ( #token("SingleValueMapper", "Identifier"):Identifier #as Type:Identifier
                , #token("set", "Identifier"):Identifier
                ,   ( ptr(SelfId:Int)
                    , ptr(ValueId:Int)
                    , .PtrList
                    )
                )
            => rustValuesToMx((V, .ValueList), (mxStringValue(StorageKey), .MxValueList)) ~> MX#storageStore
            ...
        </k>
        <values>
            SelfId |-> struct
                        ( Type
                        , #token("storage_key", "Identifier"):Identifier |-> StorageKeyId:Int
                            _:Map
                        )
            StorageKeyId |-> StorageKey:String
            ValueId |-> V:Value
            ...
        </values>

    rule
        <k>
            normalizedMethodCall
                ( #token("SingleValueMapper", "Identifier"):Identifier #as Type:Identifier
                , #token("set_if_empty", "Identifier"):Identifier
                ,   ( ptr(SelfId:Int)
                    , ptr(ValueId:Int)
                    , .PtrList
                    )
                )
            => MX#storageLoad(mxStringValue(StorageKey), rustDestination(-1, noType))
                ~> setIfEmpty
                ~> rustValuesToMx((V, .ValueList), (mxStringValue(StorageKey), .MxValueList))
                ~> MX#storageStore
            ...
        </k>
        <values>
            SelfId |-> struct
                        ( Type
                        , #token("storage_key", "Identifier"):Identifier |-> StorageKeyId:Int
                            _:Map
                        )
            StorageKeyId |-> StorageKey:String
            ValueId |-> V:Value
            ...
        </values>

    rule mxRustEmptyValue(noType) ~> storeHostValue(...) ~> setIfEmpty
        => .K
    rule storeHostValue(... value: V:MxValue)
          ~> setIfEmpty ~> _:KItem ~> MX#storageStore
        => .K
        requires notBool isMxEmptyValue(V)

    rule
        <k>
            normalizedMethodCall
                ( #token("SingleValueMapper", "Identifier"):Identifier #as Type:Identifier
                , #token("get", "Identifier"):Identifier
                ,   ( ptr(SelfId:Int)
                    , .PtrList
                    )
                )
            => MX#storageLoad(mxStringValue(StorageKey), rustDestination(NextId, ResultType))
                ~> mxRustLoadPtr(NextId)
            ...
        </k>
        <values>
            SelfId |-> struct
                        ( Type
                        , #token("storage_key", "Identifier"):Identifier |-> StorageKeyId:Int
                            #token("result_type", "Identifier"):Identifier |-> ResultTypeId:Int
                            _:Map
                        )
            StorageKeyId |-> StorageKey:String
            ResultTypeId |-> ResultType:MxRustType
            ...
        </values>
        <next-value-id> NextId:Int => NextId +Int 1 </next-value-id>

    syntax MxRustInstruction ::= "setIfEmpty"
endmodule

```

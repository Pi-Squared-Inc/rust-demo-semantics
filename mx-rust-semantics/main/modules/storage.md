```k

module MX-RUST-MODULES-STORAGE
    imports private COMMON-K-CELL
    imports private MX-COMMON-SYNTAX
    imports private MX-RUST-REPRESENTATION
    imports private RUST-EXECUTION-CONFIGURATION
    imports private RUST-REPRESENTATION
    imports private RUST-SHARED-SYNTAX

    rule
        normalizedMethodCall
            ( #token("SingleValueMapper", "Identifier"):Identifier #as Type:Identifier
            , #token("new", "Identifier"):Identifier
            ,   ( ptr(KeyId:Int)
                , ptr(ResultTypeId:Int)
                , .NormalizedCallParams
                )
            )
        => mxRustNewValue
            ( struct
                ( Type
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
                    , .NormalizedCallParams
                    )
                )
            => MX#storageStore(mxStringValue(StorageKey), wrappedRust(V))
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
                    , .NormalizedCallParams
                    )
                )
            => MX#storageLoad(mxStringValue(StorageKey), rustDestination(-1, noType))
                ~> setIfEmpty
                ~> MX#storageStore(mxStringValue(StorageKey), wrappedRust(V))
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
    rule storeHostValue(... value: wrappedRust(_))
          ~> setIfEmpty ~> MX#storageStore(_)
        => .K

    rule
        <k>
            normalizedMethodCall
                ( #token("SingleValueMapper", "Identifier"):Identifier #as Type:Identifier
                , #token("get", "Identifier"):Identifier
                ,   ( ptr(SelfId:Int)
                    , .NormalizedCallParams
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

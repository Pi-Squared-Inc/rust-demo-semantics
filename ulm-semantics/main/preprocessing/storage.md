```k

module ULM-PREPROCESSING-STORAGE
    imports private BYTES
    imports private COMMON-K-CELL
    imports private RUST-ERROR-SYNTAX
    imports private RUST-PREPROCESSING-CONFIGURATION
    imports private RUST-REPRESENTATION
    imports private ULM-ENCODING-SYNTAX
    imports private ULM-PREPROCESSING-SYNTAX-PRIVATE
    imports private ULM-REPRESENTATION

    rule
        <k>
            ulmPreprocessStorage
                (... fullMethodPath: Method:PathInExpression
                , storageName: StorageName:String
                )
            => ulmAddStorageMethodBody
                (... methodName: Method
                , storageName: StorageName
                , mapperValueType: MapperValue
                , appendParamsInstructions:
                    encodeStatements
                        ( buffer_id
                        ,   ( ptrValue(null, StorageName) : str
                            , paramsToEncodeValues(Params)
                            )
                        )
                )
            ...
        </k>
        <method-name> Method </method-name>
        <method-implementation> empty </method-implementation>
        <method-params> (self : $selftype , Params:NormalizedFunctionParameterList) </method-params>
        <method-return-type>
            :: single_value_mapper :: SingleValueMapper
                < MapperValue:Type , .GenericArgList >
        </method-return-type>

    rule
        <k>
            ulmAddStorageMethodBody
                (... methodName: Method:PathInExpression
                , storageName: StorageName:String
                , mapperValueType: MapperValueType:Type
                , appendParamsInstructions: Append:NonEmptyStatements
                ) => .K
            ...
        </k>
        <method-name> Method </method-name>
        <method-implementation>
            empty => block({ .InnerAttributes
                concatNonEmptyStatements
                    ( concatNonEmptyStatements
                        (   let buffer_id = :: bytes_hooks :: empty(.CallParamsList);
                            .NonEmptyStatements
                        ,   Append
                        )
                    ,   let hash = :: bytes_hooks :: hash(buffer_id , .CallParamsList);
                        let storage = :: single_value_mapper :: new(hash , .CallParamsList);
                        storage . value_type = ptrValue(null, rustType(MapperValueType));
                        .NonEmptyStatements
                    )
                storage
            })
        </method-implementation>

    syntax Identifier ::= "buffer_id"  [token]
                        | "bytes_hooks"  [token]
                        | "append_str"  [token]
                        | "append_u8"  [token]
                        | "append_u16"  [token]
                        | "append_u32"  [token]
                        | "append_u64"  [token]
                        | "append_u128"  [token]
                        | "append_u160"  [token]
                        | "append_u256"  [token]
                        | "empty"  [token]
                        | "hash"  [token]
                        | "new"  [token]
                        | "single_value_mapper"  [token]
                        | "SingleValueMapper"  [token]
                        | "storage"  [token]
                        | "str"  [token]
                        | "value_type"  [token]

    syntax NonEmptyStatementsOrError ::= encodeParam(Identifier, Type)  [function, total]
    syntax NonEmptyStatementsOrError ::= encodeParam(ExpressionOrError)  [function, total]
    syntax ExpressionOrError ::= encodeForType(Identifier, Type)  [function, total]

    rule encodeParam(Name:Identifier, T:Type)
        => encodeParam(encodeForType(Name, T))

    rule encodeParam(e(E:SemanticsError)) => E
    rule encodeParam(v(E:Expression))
        =>  let buffer_id = E;
            .NonEmptyStatements

    rule encodeForType(Name:Identifier, T:Type)
        => e(error("decodeForType: unrecognized type", ListItem(Name) ListItem(T)))
        [owise]
    rule encodeForType(Name:Identifier, u8)
        => v(:: bytes_hooks :: append_u8 ( buffer_id , Name , .CallParamsList ))
    rule encodeForType(Name:Identifier, u16)
        => v(:: bytes_hooks :: append_u16 ( buffer_id , Name , .CallParamsList ))
    rule encodeForType(Name:Identifier, u32)
        => v(:: bytes_hooks :: append_u32 ( buffer_id , Name , .CallParamsList ))
    rule encodeForType(Name:Identifier, u64)
        => v(:: bytes_hooks :: append_u64 ( buffer_id , Name , .CallParamsList ))
    rule encodeForType(Name:Identifier, u128)
        => v(:: bytes_hooks :: append_u128 ( buffer_id , Name , .CallParamsList ))
    rule encodeForType(Name:Identifier, u160)
        => v(:: bytes_hooks :: append_u160 ( buffer_id , Name , .CallParamsList ))
    rule encodeForType(Name:Identifier, u256)
        => v(:: bytes_hooks :: append_u256 ( buffer_id , Name , .CallParamsList ))

endmodule

```

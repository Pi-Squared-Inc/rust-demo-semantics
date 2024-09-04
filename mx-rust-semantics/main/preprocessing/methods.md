```k

module MX-RUST-PREPROCESSING-METHODS
    imports private COMMON-K-CELL
    imports private K-EQUAL-SYNTAX
    imports private LIST
    imports private MX-RUST-REPRESENTATION
    imports private RUST-PREPROCESSING-CONFIGURATION
    imports private RUST-REPRESENTATION
    imports private RUST-SHARED-SYNTAX
    imports private STRING

    syntax Identifier ::= "storage_mapper"  [token]

    syntax MxRustInstruction  ::= mxRustPreprocessMethods(trait: TypePath, methodNames: List)
                                | mxRustPreprocessMethod(trait: TypePath, methodName: Identifier)
                                | addStorageMethodBody
                                    ( trait: TypePath
                                    , methodName: Identifier
                                    , storageName:String
                                    , mapperValueType:MxRustTypeOrError
                                    )

    rule
        <k> mxRustPreprocessMethods(T:TypePath)
            => mxRustPreprocessMethods(T, MethodNames)
            ...
        </k>
        <trait-path> T </trait-path>
        <method-list> MethodNames:List </method-list>

    rule mxRustPreprocessMethods(_:TypePath, .List) => .K
    rule mxRustPreprocessMethods(T:TypePath, ListItem(MethodName:Identifier) Names:List)
        => mxRustPreprocessMethod(T, MethodName) ~> mxRustPreprocessMethods(T, Names)

    rule
        <k>
            mxRustPreprocessMethod(Trait:TypePath, Method:Identifier)
            => addStorageMethodBody
                (... trait: Trait, methodName: Method
                , storageName: getStorageName(Atts)
                , mapperValueType: getMapperValueType(MapperValue)
                )
            ...
        </k>
        <trait-path> Trait </trait-path>
        <method-name> Method </method-name>
        <method-implementation> empty </method-implementation>
        <method-outer-attributes> Atts:OuterAttributes </method-outer-attributes>
        <method-return-type>
            #token("SingleValueMapper", "Identifier") < MapperValue:GenericArg , .GenericArgList >
        </method-return-type>
        requires getStorageName(Atts) =/=K ""
        [priority(50)]
    rule mxRustPreprocessMethod(_Trait:TypePath, _Method:Identifier) => .K
        [priority(100)]

    rule
        <k>
            addStorageMethodBody
                (... trait: Trait:TypePath, methodName: Method:Identifier
                , storageName: StorageName:String
                , mapperValueType: MapperValueType:MxRustType) => .K
            ...
        </k>
        <trait-path> Trait </trait-path>
        <method-name> Method </method-name>
        <method-params> Params:NormalizedFunctionParameterList </method-params>
        <method-implementation>
            empty => block(buildStorageMethodBody(Params, StorageName, MapperValueType))
        </method-implementation>

    syntax String ::= getStorageName(atts:OuterAttributes)  [function, total]
    rule getStorageName() => ""
    rule getStorageName(.NonEmptyOuterAttributes) => ""
    rule getStorageName
            (   (#[ #token("storage_mapper", "Identifier") :: .SimplePathList
                    ( Name:String, .CallParamsList )
                ])
                _:NonEmptyOuterAttributes
            ) => Name
    rule getStorageName
            (   (#[ #token("view", "Identifier") :: .SimplePathList
                    ( _Name:PathExprSegments, .CallParamsList )
                ])
                Atts:NonEmptyOuterAttributes
            )
        => getStorageName(Atts)


    syntax Expression ::= concatString(Expression, Expression)  [seqstrict]
                        | toString(Expression)  [strict]
    rule concatString(ptrValue(_, S1:String), ptrValue(_, S2:String)) => ptrValue(null, S1 +String S2)
    rule toString(ptrValue(_, i32(Value:MInt{32})))
        => ptrValue(null, padLeftString(Base2String(MInt2Unsigned(Value), 16), "0", 32 divInt 4))
    rule toString(ptrValue(_, u32(Value:MInt{32})))
        => ptrValue(null, padLeftString(Base2String(MInt2Unsigned(Value), 16), "0", 32 divInt 4))
    rule toString(ptrValue(_, i64(Value:MInt{64})))
        => ptrValue(null, padLeftString(Base2String(MInt2Unsigned(Value), 16), "0", 64 divInt 4))
    rule toString(ptrValue(_, u64(Value:MInt{64})))
        => ptrValue(null, padLeftString(Base2String(MInt2Unsigned(Value), 16), "0", 64 divInt 4))
    rule toString(ptrValue(_, u128(Value:MInt{128})))
        => ptrValue(null, padLeftString(Base2String(MInt2Unsigned(Value), 16), "0", 128 divInt 4))
    rule toString(ptrValue(null, Value:String)) => ptrValue(null, Value)
    // TODO: convert all Value entries to string

    syntax String ::= padLeftString(value:String, padding:String, count:Int)  [function, total]
    rule padLeftString(...value:S, padding:P, count:C) => S
        requires C <=Int lengthString(S) orBool lengthString(P) =/=Int 1
    rule padLeftString(S:String => P +String S, P:String, _Count:Int)
        [owise]

    syntax BlockExpression ::= buildStorageMethodBody
                                  ( params: NormalizedFunctionParameterList
                                  , storageName: String
                                  , mapperValueType: MxRustType
                                  )  [function, total]
    rule buildStorageMethodBody
            (... params: (_S:SelfSort : _), Params:NormalizedFunctionParameterList
            , storageName: StorageName:String
            , mapperValueType: ValueType:MxRustType
            )
        =>  { .InnerAttributes
                #token("SingleValueMapper", "Identifier"):Identifier
                    :: #token("new", "Identifier"):PathIdentSegment
                        ( concatString(StorageName, buildParamsConcat(Params))
                        , ptrValue(null, ValueType)
                        , .CallParamsList
                        )
            }

    syntax Expression ::= buildParamsConcat(params: NormalizedFunctionParameterList)  [function , total]
    rule buildParamsConcat(.NormalizedFunctionParameterList) => ""
    rule buildParamsConcat(Param:NormalizedFunctionParameter , L:NormalizedFunctionParameterList)
        => concatString(paramToString(Param), buildParamsConcat(L))

    syntax Expression ::= paramToString(NormalizedFunctionParameter)  [function, total]
    rule paramToString(I:Identifier : _:Type) => toString(I)
    rule paramToString(S:SelfSort : _:Type) => toString(S)

    syntax MxRustTypeOrError ::= getMapperValueType(GenericArg)  [function, total]
    rule getMapperValueType(Type:GenericArg) => error("unknown Mx-Rust type", Type)
        [owise]
    rule getMapperValueType(#token("BigUint", "Identifier")) => BigUint
endmodule

```
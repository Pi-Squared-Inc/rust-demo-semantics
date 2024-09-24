```k

module MX-RUST-PREPROCESSING-METHODS
    imports private COMMON-K-CELL
    imports private K-EQUAL-SYNTAX
    imports private LIST
    imports private MX-RUST-CALLS-CONFIGURATION
    imports private MX-RUST-PREPROCESSED-ENDPOINTS-CONFIGURATION
    imports private MX-RUST-REPRESENTATION
    imports private RUST-PREPROCESSING-CONFIGURATION
    imports private RUST-REPRESENTATION
    imports private RUST-SHARED-SYNTAX
    imports private STRING

    syntax Identifier ::= "storage_mapper"  [token]

    syntax MxRustInstruction  ::= mxRustPreprocessMethods(trait: TypePath, methodNames: List)
                                | mxRustPreprocessMethod(trait: TypePath, methodName: Identifier)
                                | mxRustPreprocessStorage(trait: TypePath, methodName: Identifier)
                                | mxRustPreprocessEndpoint(trait: TypePath, methodName: Identifier)
                                | addStorageMethodBody
                                    ( trait: TypePath
                                    , methodName: Identifier
                                    , storageName:String
                                    , mapperValueType:MxRustTypeOrError
                                    )
                                | mxRustAddEndpointMapping
                                    ( trait: TypePath
                                    , methodName: Identifier
                                    , endpointName:String
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

    rule mxRustPreprocessMethod(Trait:TypePath, Method:Identifier)
        => mxRustPreprocessStorage(Trait, Method)
            ~> mxRustPreprocessEndpoint(Trait, Method)

    rule
        <k>
            mxRustPreprocessStorage(Trait:TypePath, Method:Identifier)
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
    rule mxRustPreprocessStorage(_Trait:TypePath, _Method:Identifier) => .K
        [priority(100)]

    rule
        <k>
            mxRustPreprocessEndpoint(Trait:TypePath, Method:Identifier)
            => mxRustAddEndpointMapping
                (... trait: Trait, methodName: Method
                , endpointName: getEndpointName(Atts, Method)
                )
            ...
        </k>
        <trait-path> Trait </trait-path>
        <method-name> Method </method-name>
        <method-outer-attributes> Atts:OuterAttributes </method-outer-attributes>
        requires getEndpointName(Atts, Method) =/=K ""
        [priority(50)]
    rule mxRustPreprocessEndpoint(_Trait:TypePath, _Method:Identifier) => .K
        [priority(100)]

    rule
        <k>
            mxRustAddEndpointMapping
                (... trait: _Trait:TypePath, methodName: Method:Identifier
                , endpointName: EndpointName:String
                )
            => .K
            ...
        </k>
        <mx-rust-endpoint-to-function> M:Map => M[EndpointName <- Method] </mx-rust-endpoint-to-function>
        requires notBool EndpointName in_keys(M)

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
    rule getStorageName(_:OuterAttribute Atts:NonEmptyOuterAttributes)
        => getStorageName(Atts)
        [owise]

    syntax String ::= getEndpointName(atts:OuterAttributes, default:Identifier)  [function, total]
    rule getEndpointName(, _:Identifier) => ""
    rule getEndpointName(.NonEmptyOuterAttributes, _:Identifier) => ""
    rule getEndpointName
            (   (#[ #token("init", "Identifier") :: .SimplePathList
                ])
                _:NonEmptyOuterAttributes
            , _:Identifier
            ) => "#init"
    rule getEndpointName
            (   (#[ #token("upgrade", "Identifier") :: .SimplePathList
                ])
                _:NonEmptyOuterAttributes
            , _:Identifier
            ) => "#upgrade"
    rule getEndpointName
            (   (#[ #token("endpoint", "Identifier") :: .SimplePathList
                    ( Name:Identifier :: .PathExprSegments, .CallParamsList )
                ])
                _:NonEmptyOuterAttributes
            , _:Identifier
            ) => IdentifierToString(Name)
    rule getEndpointName(_:OuterAttribute Atts:NonEmptyOuterAttributes, Default:Identifier)
        => getEndpointName(Atts, Default)
        [owise]

    syntax BlockExpression ::= buildStorageMethodBody
                                  ( params: NormalizedFunctionParameterList
                                  , storageName: String
                                  , mapperValueType: MxRustType
                                  )  [function]
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
    rule getMapperValueType(#token("BigUint", "Identifier") #as T:Type)
        => rustType(T)
endmodule

```

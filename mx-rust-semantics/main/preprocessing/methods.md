```k

module MX-RUST-PREPROCESSING-METHODS
    imports private COMMON-K-CELL
    imports private K-EQUAL-SYNTAX
    imports private LIST
    imports private MX-RUST-PREPROCESSED-ENDPOINTS-CONFIGURATION
    imports private MX-RUST-PREPROCESSED-PROXIES-CONFIGURATION
    imports private MX-RUST-REPRESENTATION
    imports private RUST-CONVERSIONS-SYNTAX
    imports private RUST-PREPROCESSING-CONFIGURATION
    imports private RUST-REPRESENTATION
    imports private RUST-SHARED-SYNTAX
    imports private STRING

    syntax Identifier ::= "storage_mapper"  [token]

    syntax MxRustInstruction  ::= mxRustPreprocessMethods
                                    ( trait: TypePath
                                    , traitType: TraitType
                                    , methodNames: List
                                    )
                                | mxRustPreprocessMethod
                                    ( trait: TypePath
                                    , traitType: TraitType
                                    , methodName: Identifier
                                    )
                                | mxRustPreprocessStorage
                                    ( traitType: TraitType
                                    , methodName: PathInExpression
                                    )
                                | mxRustPreprocessEndpoint
                                    ( traitType: TraitType
                                    , methodName: PathInExpression
                                    , defaultEndpointName: Identifier
                                    )
                                | mxRustPreprocessProxyMethod
                                    ( traitType: TraitType
                                    , methodName: PathInExpression
                                    )
                                | addStorageMethodBody
                                    ( methodName: PathInExpression
                                    , storageName:String
                                    , mapperValueType:MxRustTypeOrError
                                    )
                                | addProxyMethodBody
                                    ( methodName: PathInExpression
                                    , proxyModule: TypePathOrError
                                    )
                                | mxRustAddEndpointMapping
                                    ( methodName: PathInExpression
                                    , endpointName:String
                                    )

    rule
        <k> mxRustPreprocessMethods(T:TypePath, TType:TraitType)
            => mxRustPreprocessMethods(T, TType, MethodNames)
            ...
        </k>
        <trait-path> T </trait-path>
        <method-list> MethodNames:List </method-list>

    rule mxRustPreprocessMethods(Trait:TypePath, contract, .List) => rustMxAddContractMethods(Trait)
    rule mxRustPreprocessMethods(Trait:TypePath, proxy, .List) => rustMxAddProxyMethods(Trait)

    rule mxRustPreprocessMethods
            (T:TypePath, TType:TraitType, ListItem(MethodName:Identifier) Names:List)
        => mxRustPreprocessMethod(T, TType, MethodName)
            ~> mxRustPreprocessMethods(T, TType, Names)

    rule mxRustPreprocessMethod(Trait:TypePath, TType:TraitType, Method:Identifier)
        => mxRustPreprocessStorage(TType, typePathToPathInExpression(append(Trait, Method)))
            ~> mxRustPreprocessEndpoint
                ( TType
                , typePathToPathInExpression(append(Trait, Method))
                , Method
                )
            ~> mxRustPreprocessProxyMethod(TType, typePathToPathInExpression(append(Trait, Method)))

    rule mxRustPreprocessStorage(proxy, _Method:PathInExpression) => .K
    rule
        <k>
            mxRustPreprocessStorage(contract, Method:PathInExpression)
            => addStorageMethodBody
                (... methodName: Method
                , storageName: getStorageName(Atts)
                , mapperValueType: getMapperValueType(MapperValue)
                )
            ...
        </k>
        <method-name> Method </method-name>
        <method-implementation> empty </method-implementation>
        <method-outer-attributes> Atts:OuterAttributes </method-outer-attributes>
        <method-return-type>
            #token("SingleValueMapper", "Identifier") < MapperValue:GenericArg , .GenericArgList >
        </method-return-type>
        requires getStorageName(Atts) =/=K ""
        [priority(50)]
    rule mxRustPreprocessStorage(contract, _Method:PathInExpression) => .K
        [priority(100)]

    rule
        <k>
            mxRustPreprocessEndpoint(proxy, Method:PathInExpression, DefaultEndpointName:Identifier)
            => .K
            ...
        </k>
        <method-name> Method </method-name>
        <method-implementation>
            empty
            => block
                ( buildProxyEndpointMethod
                    ( Params
                    , getEndpointName(Atts, DefaultEndpointName)
                    , rustType(ReturnType)
                    )
                )
        </method-implementation>
        <method-outer-attributes> Atts:OuterAttributes </method-outer-attributes>
        <method-params> Params:NormalizedFunctionParameterList </method-params>
        <method-return-type> ReturnType => #token("MxRust#Proxy", "Identifier") </method-return-type>
        requires getEndpointName(Atts, DefaultEndpointName) =/=K ""
        [priority(50)]
    rule
        <k>
            mxRustPreprocessEndpoint(contract, Method:PathInExpression, DefaultEndpointName:Identifier)
            => mxRustAddEndpointMapping
                (... methodName: Method
                , endpointName: getEndpointName(Atts, DefaultEndpointName)
                )
            ...
        </k>
        <method-name> Method </method-name>
        <method-outer-attributes> Atts:OuterAttributes </method-outer-attributes>
        requires getEndpointName(Atts, DefaultEndpointName) =/=K ""
        [priority(50)]
    rule mxRustPreprocessEndpoint(contract, _Method:PathInExpression, _DefaultEndpointName:Identifier) => .K
        [priority(100)]

    rule mxRustPreprocessProxyMethod(proxy, _Method:PathInExpression) => .K
    rule
        <k>
            mxRustPreprocessProxyMethod(contract, Method:PathInExpression)
            => addProxyMethodBody
                (... methodName: Method
                , proxyModule: parentTypePath(ReturnType)
                )
            ...
        </k>
        <method-name> Method </method-name>
        <method-implementation> empty </method-implementation>
        <method-outer-attributes> Atts:OuterAttributes </method-outer-attributes>
        <method-return-type> ReturnType:TypePath </method-return-type>
        requires isProxyMethod(Atts)
    rule
        <k>
            mxRustPreprocessProxyMethod(contract, Method:PathInExpression)
            => .K
            ...
        </k>
        <method-name> Method </method-name>
        <method-outer-attributes> Atts:OuterAttributes </method-outer-attributes>
        requires notBool isProxyMethod(Atts)

    rule
        <k>
            mxRustAddEndpointMapping
                (... methodName: Method:PathInExpression
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
                (... methodName: Method:PathInExpression
                , storageName: StorageName:String
                , mapperValueType: MapperValueType:MxRustType) => .K
            ...
        </k>
        <method-name> Method </method-name>
        <method-params> Params:NormalizedFunctionParameterList </method-params>
        <method-implementation>
            empty => block(buildStorageMethodBody(Params, StorageName, MapperValueType))
        </method-implementation>

    rule
        <k>
            addProxyMethodBody
                (... methodName: Method:PathInExpression
                , proxyModule: ProxyModule:TypePath
                ) => .K
            ...
        </k>
        <method-name> Method </method-name>
        <method-params>
            SelfName:SelfSort : _
            , AddressName:Identifier : #token("ManagedAddress", "Identifier")
            , .NormalizedFunctionParameterList
        </method-params>
        <method-implementation>
            empty => block(buildProxyMethodBody(SelfName, AddressName, ProxyTrait))
        </method-implementation>
        <mx-rust-proxy-module> ProxyModule </mx-rust-proxy-module>
        <mx-rust-proxy-trait> ProxyTrait:TypePath </mx-rust-proxy-trait>

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
    rule getEndpointName
            (   (#[ #token("view", "Identifier") :: .SimplePathList
                    ( Name:Identifier :: .PathExprSegments, .CallParamsList )
                ])
                _:NonEmptyOuterAttributes
            , _:Identifier
            ) => IdentifierToString(Name)
    rule getEndpointName(_:OuterAttribute Atts:NonEmptyOuterAttributes, Default:Identifier)
        => getEndpointName(Atts, Default)
        [owise]

    syntax Bool ::= isProxyMethod(atts:OuterAttributes)  [function, total]
    rule isProxyMethod() => false
    rule isProxyMethod(.NonEmptyOuterAttributes) => false
    rule isProxyMethod
            (   (#[ #token("proxy", "Identifier") :: .SimplePathList])
                _:NonEmptyOuterAttributes
            ) => true
    rule isProxyMethod(_:OuterAttribute Atts:NonEmptyOuterAttributes)
        => isProxyMethod(Atts)
        [owise]

    syntax BlockExpression ::= buildProxyEndpointMethod
                                  ( params: NormalizedFunctionParameterList
                                  , endpointName: String
                                  , returnType: MxRustType
                                  )  [function]
    rule buildProxyEndpointMethod
            (... params: S:SelfSort : _ , Params:NormalizedFunctionParameterList
            , endpointName: Name
            , returnType: ReturnType
            )
        => { .InnerAttributes
              S . #token("endpoint_name", "Identifier") = Name;
              S . #token("args", "Identifier") =
                  (paramsToMaybeTupleElements(Params)):TupleExpression;
              S . #token("return_type", "Identifier") = ptrValue(null, ReturnType);
              S
            }

    // TODO: Move this to the Rust semantics
    syntax MaybeTupleElements ::= paramsToMaybeTupleElements(NormalizedFunctionParameterList)
                                  [function, total]
    rule paramsToMaybeTupleElements(.NormalizedFunctionParameterList) => `noTupleElements`(.KList)
    rule paramsToMaybeTupleElements(Name:Identifier : _ , .NormalizedFunctionParameterList)
        => Name ,
    rule paramsToMaybeTupleElements
            ( Name:Identifier : _
            , N:NormalizedFunctionParameter
            , Ns:NormalizedFunctionParameterList
            )
        => Name , paramsToTupleElementsNoEndComma(N , Ns)
    rule paramsToMaybeTupleElements(P , Ps:NormalizedFunctionParameterList)
        => error("Unexpected param in paramsToMaybeTupleElements", ListItem(P) ListItem(Ps)) , 
        [owise]

    syntax TupleElementsNoEndComma ::= paramsToTupleElementsNoEndComma(NormalizedFunctionParameterList)
                                        [function, total]
    rule paramsToTupleElementsNoEndComma(.NormalizedFunctionParameterList)
        => .TupleElementsNoEndComma
    rule paramsToTupleElementsNoEndComma(Name:Identifier : _ , Ps:NormalizedFunctionParameterList)
        => Name , paramsToTupleElementsNoEndComma(Ps)
    rule paramsToTupleElementsNoEndComma(P ,  Ps:NormalizedFunctionParameterList)
        => error("Unexpected param in paramsToTupleElementsNoEndComma", ListItem(P))
          , paramsToTupleElementsNoEndComma(Ps) 

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
    rule getMapperValueType(#token("ManagedBuffer", "Identifier") #as T:Type)
        => rustType(T)

    syntax BlockExpression ::= buildProxyMethodBody
                                  ( selfName: SelfSort
                                  , addressName: Identifier
                                  , proxyTrait: TypePath
                                  )  [function]
    rule buildProxyMethodBody
            (... selfName: _SelfName:SelfSort
            , addressName: AddressName:Identifier
            , proxyTrait: ProxyTrait:TypePath
            )
        =>  { .InnerAttributes
                #token("MxRust#Proxy", "Identifier"):Identifier
                    :: #token("new", "Identifier"):PathIdentSegment
                        ( AddressName
                        , rawValue(rustType(ProxyTrait))
                        , .CallParamsList
                        )
            }

endmodule

```

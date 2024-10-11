```k

module UKM-PREPROCESSING-ENDPOINTS
    imports private COMMON-K-CELL
    imports private RUST-CONVERSIONS-SYNTAX
    imports private RUST-ERROR-SYNTAX
    imports private RUST-PREPROCESSING-CONFIGURATION
    imports private RUST-SHARED-SYNTAX
    imports private UKM-PREPROCESSING-EPHEMERAL-CONFIGURATION
    imports private UKM-PREPROCESSING-SYNTAX-PRIVATE
    imports private UKM-REPRESENTATION

    rule
        <k>
            ukmPreprocessEndpoint
                ( Trait:TypePath
                , Method:Identifier
                , FullMethodPath:PathInExpression
                , Name:String
                )
            =>  ukmAddEndpointWrapper
                    ( typePathToPathInExpression(append(Trait, StringToIdentifier("ukmWrap#" +String Name)))
                    , Params
                    , ReturnType
                    , Method
                    )
                ~> ukmAddEndpointSignature
                    ( methodSignature(Name, Params)
                    , StringToIdentifier("ukmWrap#" +String Name)
                    )
            ...
        </k>
        <method-name> FullMethodPath </method-name>
        <method-params> (self : $selftype , Params:NormalizedFunctionParameterList) </method-params>
        <method-return-type> ReturnType:Type </method-return-type>


    rule ukmAddEndpointWrapper
            (... wrapperMethod: WrapperMethod:PathInExpression
            , params: Params:NormalizedFunctionParameterList
            , returnType: ReturnType:Type
            , method: ImplementationMethod:Identifier
            )
        => #ukmAddEndpointWrapper
            (... wrapperMethod: WrapperMethod
            , params: Params
            , method: ImplementationMethod
            , appendReturn: appendValue(buffer_id, return_value, ReturnType)
            , decodeStatements: decodeParams(0, Params)
            )

    rule
        <k>
            #ukmAddEndpointWrapper
                  (... wrapperMethod: WrapperMethod:PathInExpression
                  , params: Params:NormalizedFunctionParameterList
                  , method: ImplementationMethod:Identifier
                  , appendReturn: v(Append:Expression)
                  , decodeStatements: Decode:NonEmptyStatements
                  ) => .K
            ...
        </k>
        <methods>
            (.Bag =>
                <method>
                    <method-name> WrapperMethod </method-name>
                    <method-params>
                        self : $selftype , buffer_id : u64 , gas : u64 , .NormalizedFunctionParameterList
                    </method-params>
                    <method-return-type> ():Type </method-return-type>
                    <method-implementation>
                        block({
                            .InnerAttributes
                            :: state_hooks :: setGasLeft(gas , .CallParamsList);
                            concatNonEmptyStatements
                                ( Decode
                                , let return_value = callMethod(ImplementationMethod, Params);
                                  let buffer_id = :: bytes_hooks :: empty(.CallParamsList);
                                  let buffer_id = Append;
                                  :: state_hooks :: setOutput(buffer_id , .CallParamsList);
                                  :: state_hooks :: setStatus(:: ukm :: EVMC_SUCCESS , .CallParamsList);
                                )
                        })
                    </method-implementation>
                    <method-outer-attributes> `emptyOuterAttributes`(.KList) </method-outer-attributes>
                </method>
            )
            ...
        </methods>

    rule
        <k>
            ukmAddEndpointSignature(Signature:String, Method:Identifier) => .K
            ...
        </k>
        <ukm-endpoint-signatures>
            Signatures:Map => Signatures[Signature <- Method]
        </ukm-endpoint-signatures>
        requires notBool (Signature in_keys(Signatures))


    rule
        <k>
            ukmAddDispatcher(TypePath) => .K
            ...
        </k>
        <ukm-endpoint-signatures>
            Signatures:Map
        </ukm-endpoint-signatures>
        <methods>
            (.Bag =>
                <method>
                    <method-name>
                        typePathToPathInExpression(append(TypePath, dispatcherMethodIdentifier))
                    </method-name>
                    <method-params>
                        self : $selftype , gas : u64, .NormalizedFunctionParameterList
                    </method-params>
                    <method-return-type> ():Type </method-return-type>
                    <method-implementation>
                        block({
                            .InnerAttributes
                            concatNonEmptyStatements
                                (   let buffer_id = ukm :: CallData();
                                    let ( buffer_id | .PatternNoTopAlts
                                        , signature | .PatternNoTopAlts
                                        , .Patterns
                                        ) = decodeSignature(buffer_id);
                                    .NonEmptyStatements
                                ,   signatureToCall(signature, keys_list(Signatures), Signatures, buffer_id, gas)
                                    .NonEmptyStatements
                                )
                        })
                    </method-implementation>
                    <method-outer-attributes> `emptyOuterAttributes`(.KList) </method-outer-attributes>
                </method>
            )
            ...
        </methods>

    rule dispatcherMethodIdentifier => #token("ukm#dispatch#method", "Identifier")

    syntax Identifier ::= "buffer_id"  [token]
                        | "signature"  [token]
                        | "gas"  [token]
                        | "state_hooks"  [token]
                        | "setGasLeft"  [token]
                        | "setOutput"  [token]
                        | "setStatus"  [token]
                        | "return_value"  [token]
                        | "bytes_hooks"  [token]
                        | "append_u8"  [token]
                        | "append_u16"  [token]
                        | "append_u32"  [token]
                        | "append_u64"  [token]
                        | "decode_u8"  [token]
                        | "decode_u16"  [token]
                        | "decode_u32"  [token]
                        | "decode_u64"  [token]
                        | "decode_str"  [token]
                        | "empty"  [token]
                        | "ukm"  [token]
                        | "CallData"  [token]
                        | "EVMC_BAD_JUMP_DESTINATION"  [token]
                        | "EVMC_SUCCESS"  [token]

    syntax StringOrError  ::= methodSignature(String, NormalizedFunctionParameterList)  [function, total]
                            | signatureTypes(NormalizedFunctionParameterList)  [function, total]
                            | signatureType(Type)  [function, total]

    rule methodSignature(S:String, Ps:NormalizedFunctionParameterList)
        => concat(concat(S +String "(", signatureTypes(Ps)), ")")

    rule signatureTypes(.NormalizedFunctionParameterList) => ""
    rule signatureTypes(_ : T:Type , .NormalizedFunctionParameterList)
        => signatureType(T)
    rule signatureTypes
            ( _ : T:Type
            , ((_:NormalizedFunctionParameter , _:NormalizedFunctionParameterList)
                #as Ps:NormalizedFunctionParameterList)
            )
        => concat(signatureType(T), concat(",", signatureTypes(Ps)))

    rule signatureType(u8) => "Uint8"
    rule signatureType(u16) => "Uint16"
    rule signatureType(u32) => "Uint32"
    rule signatureType(u64) => "Uint64"
    rule signatureType(T) => error("Unknown type in signatureType:", ListItem(T))
        [owise]

    syntax Statement ::= signatureToCall
                                    ( signature: Identifier
                                    , signatures: List
                                    , signatureToMethod: Map
                                    , bufferId: Identifier
                                    , gas: Identifier
                                    ) [function, total]
    rule signatureToCall
            (... signature: _:Identifier
            , signatures: .List
            , signatureToMethod: _:Map
            , bufferId: _:Identifier
            , gas: _:Identifier
            )
        // TODO: Is this the right kind of error?
        => :: state_hooks :: setStatus(:: ukm :: EVMC_BAD_JUMP_DESTINATION , .CallParamsList);

    rule signatureToCall
            (... signature: Signature:Identifier
            , signatures: ListItem(CurrentSignature:String) Signatures:List
            , signatureToMethod: (CurrentSignature |-> Method:Identifier _:Map) #as SignatureToMethod:Map
            , bufferId: BufferId:Identifier
            , gas: Gas:Identifier
            )
        =>  if signature == CurrentSignature {
                .InnerAttributes
                self . Method ( BufferId , Gas , .CallParamsList );
                .NonEmptyStatements
            } else {
                .InnerAttributes
                signatureToCall(Signature, Signatures, SignatureToMethod, BufferId, Gas)
                .NonEmptyStatements
            };

    syntax Expression ::= decodeSignature(Identifier)  [function, total]
    rule decodeSignature(BufferId) => :: bytes_hooks :: decode_str ( BufferId , .CallParamsList )

    syntax ExpressionOrError ::= appendValue(bufferId: Identifier, value: Identifier, Type)  [function, total]
    rule appendValue(BufferId:Identifier, Value:Identifier, u8)
        => v(:: bytes_hooks :: append_u8 ( BufferId , Value , .CallParamsList ))
    rule appendValue(BufferId:Identifier, Value:Identifier, u16)
        => v(:: bytes_hooks :: append_u16 ( BufferId , Value , .CallParamsList ))
    rule appendValue(BufferId:Identifier, Value:Identifier, u32)
        => v(:: bytes_hooks :: append_u32 ( BufferId , Value , .CallParamsList ))
    rule appendValue(BufferId:Identifier, Value:Identifier, u64)
        => v(:: bytes_hooks :: append_u64 ( BufferId , Value , .CallParamsList ))
    rule appendValue(BufferId:Identifier, _Value:Identifier, ()) => v(BufferId)
    rule appendValue(BufferId:Identifier, Value:Identifier, T:Type)
        => e(error("appendValue: unrecognized type", ListItem(BufferId) ListItem(Value) ListItem(T)))
        [owise]

    syntax NonEmptyStatementsOrError ::= decodeParams(Int, NormalizedFunctionParameterList)  [function, total]
    rule decodeParams(_:Int, .NormalizedFunctionParameterList) => .NonEmptyStatements
    rule decodeParams(Index:Int, _ : T:Type , Ps:NormalizedFunctionParameterList)
        => concat(decodeParam(Index, T), decodeParams(Index +Int 1, Ps))

    syntax NonEmptyStatementsOrError ::= decodeParam(Int, Type)  [function, total]
    syntax NonEmptyStatementsOrError ::= decodeParam(Int, ExpressionOrError)  [function, total]
    syntax ExpressionOrError ::= decodeForType(Type)  [function, total]
    rule decodeParam(I:Int, T:Type) => decodeParam(I, decodeForType(T))
    rule decodeParam(_:Int, e(E:SemanticsError)) => E
    rule decodeParam(Index:Int, v(E:Expression))
        =>  let ( buffer_id | .PatternNoTopAlts
                , StringToIdentifier("v" +String Int2String(Index)) | .PatternNoTopAlts
                , .Patterns
                ) = E;
            .NonEmptyStatements

    rule decodeForType(T:Type) => e(error("decodeForType: unrecognized type", ListItem(T)))
        [owise]
    rule decodeForType(u8) => v(:: bytes_hooks :: decode_u8 ( buffer_id , .CallParamsList ))
    rule decodeForType(u16) => v(:: bytes_hooks :: decode_u16 ( buffer_id , .CallParamsList ))
    rule decodeForType(u32) => v(:: bytes_hooks :: decode_u32 ( buffer_id , .CallParamsList ))
    rule decodeForType(u64) => v(:: bytes_hooks :: decode_u64 ( buffer_id , .CallParamsList ))

    syntax Expression ::= callMethod(Identifier, NormalizedFunctionParameterList)  [function, total]
    syntax Expression ::= callMethod(Identifier, CallParamsList)  [function, total]
    syntax CallParamsList ::= buildArgs(Int, NormalizedFunctionParameterList)  [function, total]

    rule callMethod(Method:Identifier, Ps:NormalizedFunctionParameterList)
        => callMethod(Method, buildArgs(0, Ps))

    rule callMethod(Method:Identifier, .CallParamsList)
        => self . Method ( )
    rule callMethod(Method:Identifier, (_ , _:CallParamsList) #as Ps:CallParamsList)
        => self . Method ( Ps )

    rule buildArgs(_:Int, .NormalizedFunctionParameterList) => .CallParamsList
    rule buildArgs(Index:Int, _:NormalizedFunctionParameter , Ps:NormalizedFunctionParameterList)
        => StringToIdentifier("v" +String Int2String(Index)) , buildArgs(Index +Int 1, Ps)

endmodule

```

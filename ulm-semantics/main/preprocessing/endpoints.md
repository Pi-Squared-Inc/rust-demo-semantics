```k

module ULM-PREPROCESSING-ENDPOINTS
    imports private COMMON-K-CELL
    imports private RUST-CONVERSIONS-SYNTAX
    imports private RUST-ERROR-SYNTAX
    imports private RUST-PREPROCESSING-CONFIGURATION
    imports private RUST-SHARED-SYNTAX
    imports private ULM-COMMON-TOOLS-SYNTAX
    imports private ULM-ENCODING-SYNTAX
    imports private ULM-PREPROCESSING-EPHEMERAL-CONFIGURATION
    imports private ULM-PREPROCESSING-SYNTAX-PRIVATE
    imports private ULM-ENCODING-SYNTAX
    imports private ULM-REPRESENTATION

    rule
        <k>
            ulmPreprocessEndpoint
                ( Trait:TypePath
                , Method:Identifier
                , FullMethodPath:PathInExpression
                , Name:String
                )
            =>  ulmAddEndpointWrapper
                    ( typePathToPathInExpression(append(Trait, StringToIdentifier("ulmWrap#" +String Name)))
                    , Params
                    , ReturnType
                    , Method
                    )
                ~> ulmAddEndpointSignature
                    ( methodSignature(Name, Params)
                    , StringToIdentifier("ulmWrap#" +String Name)
                    )
            ...
        </k>
        <method-name> FullMethodPath </method-name>
        <method-params> (self : $selftype , Params:NormalizedFunctionParameterList) </method-params>
        <method-return-type> ReturnType:Type </method-return-type>


    rule ulmAddEndpointWrapper
            (... wrapperMethod: WrapperMethod:PathInExpression
            , params: Params:NormalizedFunctionParameterList
            , returnType: ReturnType:Type
            , method: ImplementationMethod:Identifier
            )
        => #ulmAddEndpointWrapper
            (... wrapperMethod: WrapperMethod
            , params: Params
            , method: ImplementationMethod
            , appendReturn: codegenValuesEncoder(buffer_id, (return_value : ReturnType , .EncodeValues))
            , decodeStatements: decodeParams(0, Params)
            )

    rule
        <k>
            #ulmAddEndpointWrapper
                  (... wrapperMethod: WrapperMethod:PathInExpression
                  , params: Params:NormalizedFunctionParameterList
                  , method: ImplementationMethod:Identifier
                  , appendReturn: Append:NonEmptyStatements
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
                                , concatNonEmptyStatements
                                    (   let return_value = callMethod(ImplementationMethod, Params);
                                        let buffer_id = :: bytes_hooks :: empty(.CallParamsList);
                                        Append
                                    ,   :: state_hooks :: setOutput(buffer_id , .CallParamsList);
                                        :: state_hooks :: setStatus(:: ulm :: EVMC_SUCCESS , .CallParamsList);
                                        .NonEmptyStatements
                                    )
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
            ulmAddEndpointSignature(Signature:Bytes, Method:Identifier) => .K
            ...
        </k>
        <ulm-endpoint-signatures>
            Signatures:Map => Signatures[Signature <- Method]
        </ulm-endpoint-signatures>
        requires notBool (Signature in_keys(Signatures))


    rule
        <k>
            ulmAddDispatcher(TypePath) => .K
            ...
        </k>
        <ulm-endpoint-signatures>
            Signatures:Map
        </ulm-endpoint-signatures>
        <methods>
            (.Bag =>
                <method>
                    <method-name>
                        typePathToPathInExpression(append(TypePath, dispatcherMethodIdentifier))
                    </method-name>
                    <method-params>
                        self : $selftype , create : bool , gas : u64 , .NormalizedFunctionParameterList
                    </method-params>
                    <method-return-type> ():Type </method-return-type>
                    <method-implementation>
                        block({
                            .InnerAttributes
                            let buffer_id = :: ulm :: CallData();
                            if create {
                                .InnerAttributes
                                self . ulmWrap##init ( buffer_id , gas , .CallParamsList );
                                .NonEmptyStatements
                            } else {
                                .InnerAttributes
                                let ( buffer_id | .PatternNoTopAlts
                                    , signature | .PatternNoTopAlts
                                    , .Patterns
                                    ) = decodeSignature(buffer_id);
                                signatureToCall(signature, keys_list(Signatures), Signatures, buffer_id, gas)
                                .NonEmptyStatements
                            };
                            .NonEmptyStatements
                        })
                    </method-implementation>
                    <method-outer-attributes> `emptyOuterAttributes`(.KList) </method-outer-attributes>
                </method>
            )
            ...
        </methods>

    syntax Identifier ::= "buffer_id"  [token]
                        | "create"  [token]
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
                        | "append_u128"  [token]
                        | "append_u160"  [token]
                        | "append_u256"  [token]
                        | "append_bool"  [token]
                        | "append_str"  [token]
                        | "decode_u8"  [token]
                        | "decode_u16"  [token]
                        | "decode_u32"  [token]
                        | "decode_u64"  [token]
                        | "decode_u128"  [token]
                        | "decode_u160"  [token]
                        | "decode_u256"  [token]
                        | "decode_str"  [token]
                        | "decode_signature"  [token]
                        | "empty"  [token]
                        | "equals"  [token]
                        | "ulm"  [token]
                        | "ulmWrap##init"  [token]
                        | "CallData"  [token]
                        | "EVMC_REVERT"  [token]
                        | "EVMC_SUCCESS"  [token]

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
        => :: state_hooks :: setStatus(:: ulm :: EVMC_REVERT , .CallParamsList);

    rule signatureToCall
            (... signature: Signature:Identifier
            , signatures: ListItem(CurrentSignature:Bytes) Signatures:List
            , signatureToMethod: (CurrentSignature |-> Method:Identifier _:Map) #as SignatureToMethod:Map
            , bufferId: BufferId:Identifier
            , gas: Gas:Identifier
            )
        =>  if :: bytes_hooks :: equals
                    ( Signature , ulmBytesNew(CurrentSignature) , .CallParamsList ) {
                .InnerAttributes
                self . Method ( BufferId , Gas , .CallParamsList );
                .NonEmptyStatements
            } else {
                .InnerAttributes
                signatureToCall(Signature, Signatures, SignatureToMethod, BufferId, Gas)
                .NonEmptyStatements
            };

    syntax Expression ::= decodeSignature(Identifier)  [function, total]
    rule decodeSignature(BufferId) => :: bytes_hooks :: decode_signature ( BufferId , .CallParamsList )

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
    rule decodeForType(u128) => v(:: bytes_hooks :: decode_u128 ( buffer_id , .CallParamsList ))
    rule decodeForType(u160) => v(:: bytes_hooks :: decode_u160 ( buffer_id , .CallParamsList ))
    rule decodeForType(u256) => v(:: bytes_hooks :: decode_u256 ( buffer_id , .CallParamsList ))

    syntax Expression ::= callMethod(Identifier, NormalizedFunctionParameterList)  [function, total]
    syntax Expression ::= #callMethod(Identifier, CallParamsList)  [function, total]
    syntax CallParamsList ::= buildArgs(Int, NormalizedFunctionParameterList)  [function, total]

    rule callMethod(Method:Identifier, Ps:NormalizedFunctionParameterList)
        => #callMethod(Method, buildArgs(0, Ps))

    rule #callMethod(Method:Identifier, .CallParamsList)
        => self . Method ( )
    rule #callMethod(Method:Identifier, (_ , _:CallParamsList) #as Ps:CallParamsList)
        => self . Method ( Ps )

    rule buildArgs(_:Int, .NormalizedFunctionParameterList) => .CallParamsList
    rule buildArgs(Index:Int, _:NormalizedFunctionParameter , Ps:NormalizedFunctionParameterList)
        => StringToIdentifier("v" +String Int2String(Index)) , buildArgs(Index +Int 1, Ps)

endmodule

```

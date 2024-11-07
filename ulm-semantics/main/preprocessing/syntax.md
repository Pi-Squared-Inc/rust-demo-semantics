```k

module ULM-PREPROCESSING-SYNTAX
    imports INT-SYNTAX

    syntax ULMInstruction ::= "ulmPreprocessCrates"
endmodule

module ULM-PREPROCESSING-SYNTAX-PRIVATE
    imports LIST
    imports RUST-REPRESENTATION
    imports RUST-SHARED-SYNTAX
    imports ULM-REPRESENTATION

    syntax ULMInstruction ::= ulmPreprocessTraits(List)
                            | ulmPreprocessTrait(TypePath)
                            | ulmPreprocessMethods(trait: TypePath, List)
                            | ulmPreprocessMethod(trait: TypePath, methodId: Identifier, fullMethodPath: PathInExpression)
                            | ulmPreprocessEndpoint
                                ( trait: TypePath
                                , method: Identifier
                                , fullMethodPath: PathInExpression
                                , endpointName: String
                                )
                            | ulmAddEndpointWrapper
                                ( wrapperMethod: PathInExpression
                                , params: NormalizedFunctionParameterList
                                , returnType: Type
                                , method: Identifier
                                )
                            | #ulmAddEndpointWrapper
                                ( wrapperMethod: PathInExpression
                                , params: NormalizedFunctionParameterList
                                , method: Identifier
                                , appendReturn: NonEmptyStatementsOrError
                                , decodeStatements: NonEmptyStatementsOrError
                                )
                            | ulmAddEndpointSignature(signature: BytesOrError, method: Identifier)
                            | ulmAddDispatcher(TypePath)
                            | ulmPreprocessStorage
                                ( fullMethodPath: PathInExpression
                                , storageName: String
                                )
                            | ulmAddStorageMethodBody
                                  ( methodName: PathInExpression
                                  , storageName: String
                                  , mapperValueType: Type
                                  , appendParamsInstructions: NonEmptyStatementsOrError
                                  )
                            | ulmPreprocessEvent
                                ( fullMethodPath: PathInExpression
                                , eventName: String
                                )

endmodule

```

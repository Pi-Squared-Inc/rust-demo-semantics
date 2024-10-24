```k

module UKM-PREPROCESSING-SYNTAX
    imports INT-SYNTAX

    syntax UKMInstruction ::= "ukmPreprocessCrates"
endmodule

module UKM-PREPROCESSING-SYNTAX-PRIVATE
    imports LIST
    imports RUST-REPRESENTATION
    imports RUST-SHARED-SYNTAX
    imports UKM-REPRESENTATION

    syntax UKMInstruction ::= ukmPreprocessTraits(List)
                            | ukmPreprocessTrait(TypePath)
                            | ukmPreprocessMethods(trait: TypePath, List)
                            | ukmPreprocessMethod(trait: TypePath, methodId: Identifier, fullMethodPath: PathInExpression)
                            | ukmPreprocessEndpoint
                                ( trait: TypePath
                                , method: Identifier
                                , fullMethodPath: PathInExpression
                                , endpointName: String
                                )
                            | ukmAddEndpointWrapper
                                ( wrapperMethod: PathInExpression
                                , params: NormalizedFunctionParameterList
                                , returnType: Type
                                , method: Identifier
                                )
                            | #ukmAddEndpointWrapper
                                ( wrapperMethod: PathInExpression
                                , params: NormalizedFunctionParameterList
                                , method: Identifier
                                , appendReturn: ExpressionOrError
                                , decodeStatements: NonEmptyStatementsOrError
                                )
                            | ukmAddEndpointSignature(signature: BytesOrError, method: Identifier)
                            | ukmAddDispatcher(TypePath)
                            | ukmPreprocessStorage
                                ( fullMethodPath: PathInExpression
                                , storageName: String
                                )
                            | ukmAddStorageMethodBody
                                  ( methodName: PathInExpression
                                  , storageName: String
                                  , mapperValueType: Type
                                  , appendParamsInstructions: NonEmptyStatementsOrError
                                  )
                            | ukmPreprocessEvent
                                ( fullMethodPath: PathInExpression
                                , eventName: String
                                )

endmodule

```

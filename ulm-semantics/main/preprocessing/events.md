```k

module ULM-PREPROCESSING-EVENTS
    imports private COMMON-K-CELL
    imports private RUST-ERROR-SYNTAX
    imports private RUST-PREPROCESSING-CONFIGURATION
    imports private ULM-ENCODING-SYNTAX
    imports private ULM-PREPROCESSING-SYNTAX-PRIVATE

    syntax Identifier ::= "bytes_hooks"  [token]
                        | "log_buffer"  [token]
                        | "empty"  [token]
                        | "Log0"  [token]
                        | "Log1"  [token]
                        | "Log2"  [token]
                        | "Log3"  [token]
                        | "Log4"  [token]
                        | "ulm"  [token]

    syntax UkmInstruction ::= #ulmPreprocessEvent
                                  ( method: PathInExpression
                                  , appendLastParam: NonEmptyStatementsOrError
                                  , logIdentifier: IdentifierOrError
                                  , eventSignature: ValueOrError
                                  )

    rule
        <k>
            ulmPreprocessEvent
                (... fullMethodPath: Method:PathInExpression
                , eventName: EventName:String
                )
            // TODO: This handles a very specific type of event: all fields
            // but the last one are indexed. We should handle generic events.
            => #ulmPreprocessEvent
                ( Method
                , codegenValuesEncoder
                    ( log_buffer
                    , paramsToEncodeValues
                        ( last(Param, Params)
                        , .NormalizedFunctionParameterList
                        )
                    )
                , findLogIdentifier(1 +Int length(Params))
                , eventSignature(EventName, (Param , Params))
                )
            ...
        </k>
        <method-name> Method </method-name>
        <method-params> (self : $selftype , Param:NormalizedFunctionParameter, Params:NormalizedFunctionParameterList) </method-params>
        <method-implementation> empty </method-implementation>
        <method-return-type> () </method-return-type>

    rule
        <k>
            #ulmPreprocessEvent
                (... method: Method:PathInExpression
                , appendLastParam: AppendLast:NonEmptyStatements
                , logIdentifier: LogIdentifier:Identifier
                , eventSignature: EventSignature:Value
                )
            => .K
            ...
        </k>
        <method-name> Method </method-name>
        <method-params> (self : $selftype , Param:NormalizedFunctionParameter, Params:NormalizedFunctionParameterList) </method-params>
        <method-implementation>
            empty => block({
                .InnerAttributes
                concatNonEmptyStatements
                    (   let log_buffer = :: bytes_hooks :: empty ( .CallParamsList );
                        AppendLast
                    ,   :: ulm :: LogIdentifier
                            ( ptrValue(null, EventSignature)
                            , concatCallParamsList
                                ( paramsToArgs(allButLast(Param, Params))
                                , (log_buffer , .CallParamsList)
                                )
                            );
                        .NonEmptyStatements
                    )
            })
        </method-implementation>
        <method-return-type> () </method-return-type>

    syntax IdentifierOrError ::= findLogIdentifier(Int)  [function, total]
    rule findLogIdentifier(1) => Log1
    rule findLogIdentifier(2) => Log2
    rule findLogIdentifier(3) => Log3
    rule findLogIdentifier(4) => Log4
    rule findLogIdentifier(I:Int) => error("findLogIdentifier: unhandled arity", ListItem(I))
        [owise]

    syntax CallParamsList ::= paramsToArgs(NormalizedFunctionParameterList)  [function, total]
    rule paramsToArgs(.NormalizedFunctionParameterList) => .CallParamsList
    rule paramsToArgs((P:Identifier : _:Type) , Ps:NormalizedFunctionParameterList)
        => P , paramsToArgs(Ps)
    rule paramsToArgs((S:SelfSort : _:Type) , Ps:NormalizedFunctionParameterList)
        => S , paramsToArgs(Ps)

endmodule

```

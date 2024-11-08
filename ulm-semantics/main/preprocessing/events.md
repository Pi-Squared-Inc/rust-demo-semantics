```k

module ULM-PREPROCESSING-EVENTS
    imports private COMMON-K-CELL
    imports private RUST-ERROR-SYNTAX
    imports private RUST-PREPROCESSING-CONFIGURATION
    imports private ULM-ENCODING-SYNTAX
    imports private ULM-PREPROCESSING-SYNTAX-PRIVATE

    syntax Identifier ::= "bytes_hooks"  [token]
                        | "data"  [token]
                        | "empty"  [token]
                        | "Log0"  [token]
                        | "Log1"  [token]
                        | "Log2"  [token]
                        | "Log3"  [token]
                        | "Log4"  [token]
                        | "ulm"  [token]

    syntax UkmInstruction ::= #ulmPreprocessEvent
                                  ( method: PathInExpression
                                  , appendLastParam: ExpressionOrError
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
                , appendParamToBytes(data, last(Param, Params))
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
                , appendLastParam: v(AppendLast:Expression)
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
                let data = :: bytes_hooks :: empty ( .CallParamsList );
                let data = AppendLast;
                :: ulm :: LogIdentifier
                    ( ptrValue(null, EventSignature)
                    , concatCallParamsList
                        ( paramsToArgs(allButLast(Param, Params))
                        , (data , .CallParamsList)
                        )
                    );
                .NonEmptyStatements
            })
        </method-implementation>
        <method-return-type> () </method-return-type>

    syntax ExpressionOrError ::= appendParamToBytes
                                    ( bufferId: Identifier
                                    , NormalizedFunctionParameter
                                    )  [function, total]
    rule appendParamToBytes(B:Identifier, (I:Identifier : T:Type)) => appendValue(B, I, T)
    rule appendParamToBytes(B, P)
        => e(error("appendParamToBytes: unrecognized param", ListItem(B) ListItem(P)))
        [owise]

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

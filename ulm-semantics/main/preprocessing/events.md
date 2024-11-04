```k

module ULM-PREPROCESSING-EVENTS
    imports private COMMON-K-CELL
    imports private RUST-PREPROCESSING-CONFIGURATION
    imports private ULM-PREPROCESSING-SYNTAX-PRIVATE

    rule 
        <k>
            ulmPreprocessEvent
                (... fullMethodPath: Method:PathInExpression
                , eventName: _EventName:String
                )
            => .K
            ...
        </k>
        <method-name> Method </method-name>
        <method-implementation>
            empty => block({.InnerAttributes .NonEmptyStatements})
        </method-implementation>
        <method-return-type> () </method-return-type>

endmodule

```
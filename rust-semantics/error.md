```k

module RUST-ERROR-SYNTAX
    imports RUST-REPRESENTATION

    syntax ValueListOrError ::= concat(ValueOrError, ValueListOrError)  [function, total]
    syntax PtrListOrError ::= concat(Ptr, PtrListOrError)  [function, total]
    syntax StringOrError ::= concat(StringOrError, StringOrError)  [function, total]
    syntax NonEmptyStatementsOrError ::= concat(NonEmptyStatementsOrError, NonEmptyStatementsOrError)  [function, total]
    syntax PtrValueOrError ::= wrapPtrValueOrError(Ptr, ValueOrError)  [function, total]
    syntax TypePathOrError ::= doubleColonOrError(TypePathSegmentsOrError)  [function, total]
    syntax TypePathOrError ::= injectOrError(TypePathSegmentsOrError) [function, total]
    syntax TypePathSegmentsOrError ::= concat(TypePathSegment, TypePathSegmentsOrError)  [function, total]
    syntax ExpressionOrError ::= andOrError(ExpressionOrError, ExpressionOrError)  [function, total]
    syntax ExpressionOrError ::= addOrError(ExpressionOrError, ExpressionOrError)  [function, total]
    syntax ValueOrError ::= tupleOrError(ValueListOrError)  [function, total]
endmodule

module RUST-ERROR
    imports private RUST-ERROR-SYNTAX

    rule concat(P:Ptr, L:PtrList) => P , L
    rule concat(_:Ptr, E:SemanticsError) => E

    rule concat(V:Value, L:ValueList) => V , L
    rule concat(_:Value, E:SemanticsError) => E
    rule concat(E:SemanticsError, _:ValueListOrError) => E

    rule concat(S1:String:StringOrError, S2:String:StringOrError) => S1 +String S2
    rule concat(_:String:StringOrError, E:SemanticsError:StringOrError) => E
    rule concat(E:SemanticsError:StringOrError, _:StringOrError) => E
    rule concat(S1:StringOrError, S2:StringOrError)
        => error("concat(StringOrError, StringOrError): Unknown error", ListItem(S1) ListItem(S2))
        [owise]

    rule concat(S1:NonEmptyStatements, S2:NonEmptyStatements) => concatNonEmptyStatements(S1, S2)
    rule concat(_:NonEmptyStatements, E:SemanticsError) => E
    rule concat(E:SemanticsError, _:NonEmptyStatementsOrError) => E

    rule wrapPtrValueOrError(P:Ptr, V:Value) => ptrValue(P, V)
    rule wrapPtrValueOrError(_:Ptr, E:SemanticsError) => E

    rule doubleColonOrError(E:SemanticsError) => E
    rule doubleColonOrError(P:TypePathSegments) => :: P

    rule injectOrError(E:SemanticsError) => E
    rule injectOrError(P:TypePathSegments) => P

    rule concat(_:TypePathSegment, E) => E
    rule concat(S:TypePathSegment, Ss:TypePathSegments) => S :: Ss

    rule andOrError(_:ExpressionOrError, e(E:SemanticsError)) => e(E)
    rule andOrError(e(E:SemanticsError), v(_:Expression)) => e(E)
    rule andOrError(v(E1:Expression), v(E2:Expression)) => v(E1 && E2)

    rule addOrError(_:ExpressionOrError, e(E:SemanticsError)) => e(E)
    rule addOrError(e(E:SemanticsError), v(_:Expression)) => e(E)
    rule addOrError(v(E1:Expression), v(E2:Expression)) => v(E1 + E2)

    rule tupleOrError(L:ValueList) => tuple(L)
    rule tupleOrError(E:SemanticsError) => E
endmodule

```

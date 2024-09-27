```k

module RUST-ERROR-SYNTAX
    imports RUST-REPRESENTATION

    syntax ValueListOrError ::= concat(ValueOrError, ValueListOrError)  [function, total]
    syntax PtrListOrError ::= concat(Ptr, PtrListOrError)  [function, total]
    syntax PtrValueOrError ::= wrapPtrValueOrError(Ptr, ValueOrError)  [function, total]
    syntax TypePathOrError ::= doubleColonOrError(TypePathSegmentsOrError)  [function, total]
    syntax TypePathOrError ::= injectOrError(TypePathSegmentsOrError) [function, total]
    syntax TypePathSegmentsOrError ::= concat(TypePathSegment, TypePathSegmentsOrError)  [function, total]
    syntax ExpressionOrError ::= andOrError(ExpressionOrError, ExpressionOrError)  [function, total]
    syntax ValueOrError ::= tupleOrError(ValueListOrError)  [function, total]
endmodule

module RUST-ERROR
    imports private RUST-ERROR-SYNTAX

    rule concat(P:Ptr, L:PtrList) => P , L
    rule concat(_:Ptr, E:SemanticsError) => E

    rule concat(V:Value, L:ValueList) => V , L
    rule concat(_:Value, E:SemanticsError) => E
    rule concat(E:SemanticsError, _:ValueListOrError) => E
    rule concat(E:ValueOrError, L:ValueListOrError)
        => error("unexpected branch (concat(ValueOrError, ValueListOrError))", ListItem(E) ListItem(L))
        [owise]

    rule wrapPtrValueOrError(P:Ptr, V:Value) => ptrValue(P, V)
    rule wrapPtrValueOrError(_:Ptr, E:SemanticsError) => E

    rule doubleColonOrError(E:SemanticsError) => E
    rule doubleColonOrError(P:TypePathSegments) => :: P

    rule injectOrError(E:SemanticsError) => E
    rule injectOrError(P:TypePathSegments) => P

    rule concat(_:TypePathSegment, E) => E
    rule concat(S:TypePathSegment, Ss:TypePathSegments) => S :: Ss

    rule andOrError(_:ExpressionOrError, E:SemanticsError) => E
    rule andOrError(E:SemanticsError, _:Expression) => E
    rule andOrError(E1:Expression, E2:Expression) => E1 && E2

    rule tupleOrError(L:ValueList) => tuple(L)
    rule tupleOrError(E:SemanticsError) => E
endmodule

```

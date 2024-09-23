```k

module RUST-ERROR-SYNTAX
    imports RUST-REPRESENTATION

    syntax ValueListOrError ::= concat(ValueOrError, ValueListOrError)  [function, total]
    syntax PtrListOrError ::= concat(Ptr, PtrListOrError)  [function, total]
    syntax PtrValueOrError ::= wrapPtrValueOrError(Ptr, ValueOrError)  [function, total]
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
endmodule

```

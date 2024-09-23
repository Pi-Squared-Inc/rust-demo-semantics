```k

module RUST-ERROR
    imports private RUST-REPRESENTATION

    rule concat(V:Value, L:ValueList) => V , L
    rule concat(_:Value, E:SemanticsError) => E
    rule concat(E:SemanticsError, _:ValueListOrError) => E
    rule concat(E:ValueOrError, L:ValueListOrError)
        => error("unexpected branch (concat(ValueOrError, ValueListOrError))", ListItem(E) ListItem(L))
        [owise]
endmodule

```
```k

module ULM-EXECUTION-CASTS
    imports private RUST-REPRESENTATION
    imports private RUST-VALUE-SYNTAX
    imports private ULM-REPRESENTATION

    syntax Expression ::= ulmCastResult(ValueOrError)

    rule ulmCast(ptrValue(_, V), ptrValue(_, rustType(T))) => ulmCastResult(implicitCast(V, T))
    rule ulmCastResult(V:Value) => ptrValue(null, V)


endmodule

```

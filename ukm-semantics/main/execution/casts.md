```k

module UKM-EXECUTION-CASTS
    imports private RUST-REPRESENTATION
    imports private RUST-VALUE-SYNTAX
    imports private UKM-REPRESENTATION

    syntax Expression ::= ukmCastResult(ValueOrError)

    rule ukmCast(ptrValue(_, V), ptrValue(_, rustType(T))) => ukmCastResult(implicitCast(V, T))
    rule ukmCastResult(V:Value) => ptrValue(null, V)


endmodule

```

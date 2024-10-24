```k

module UKM-REPRESENTATION
    imports BYTES-SYNTAX
    imports INT-SYNTAX
    imports MINT
    imports RUST-VALUE-SYNTAX

    syntax UkmValue ::= ukmBytesValue(Bytes)
                      | ukmIntValue(Int)
    syntax UkmExpression  ::= ukmBytesId(MInt{64})
                            | ukmInt(MInt{64})
                            | UkmValue
    syntax KResult ::= UkmValue

    syntax Expression ::= ukmCast(Expression, Expression)  [seqstrict]
    syntax Expression ::= ukmBytesNew(Bytes)

    syntax Value ::= rustType(Type)

    syntax BytesOrError ::= Bytes | SemanticsError

endmodule

```

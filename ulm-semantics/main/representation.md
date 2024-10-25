```k

module ULM-REPRESENTATION
    imports BYTES-SYNTAX
    imports INT-SYNTAX
    imports MINT
    imports RUST-VALUE-SYNTAX

    syntax UlmValue ::= ulmBytesValue(Bytes)
                      | ulmIntValue(Int)
    syntax UlmExpression  ::= ulmBytesId(MInt{64})
                            | ulmInt(MInt{64})
                            | UlmValue
    syntax KResult ::= UlmValue

    syntax Expression ::= ulmCast(Expression, Expression)  [seqstrict]
    syntax Expression ::= ulmBytesNew(Bytes)

    syntax Value ::= rustType(Type)

    syntax BytesOrError ::= Bytes | SemanticsError

endmodule

```

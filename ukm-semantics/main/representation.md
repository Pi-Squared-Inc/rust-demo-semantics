```k

module UKM-REPRESENTATION
    imports private BYTES-SYNTAX
    imports private INT-SYNTAX
    imports private MINT
    imports private RUST-VALUE-SYNTAX

    syntax UkmValue ::= ukmBytesValue(Bytes)
                      | ukmIntValue(Int)
    syntax UkmExpression  ::= ukmBytesId(MInt{64})
                            | ukmInt(MInt{64})
                            | UkmValue
    syntax KResult ::= UkmValue

    syntax Identifier ::= "dispatcherMethodIdentifier"  [function, total]
endmodule

```

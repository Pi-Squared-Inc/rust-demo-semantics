```k

module RUST-REPRESENTATION
    imports INT
    imports MINT
    imports RUST-SHARED-SYNTAX

    syntax MInt{8}
    syntax MInt{16}
    syntax MInt{32}
    syntax MInt{64}

    syntax FunctionBodyRepresentation ::= block(BlockExpression)
                                        | "empty"
                                        | storageAccessor(StringLiteral)
    syntax NormalizedFunctionParameter ::= Identifier ":" Type
    syntax NormalizedFunctionParameterList ::= List{NormalizedFunctionParameter, ","}

    syntax Value  ::= i32(MInt{32})
                    | u32(MInt{32})
                    | i64(MInt{64})
                    | u64(MInt{64})
                    | tuple(ValueList)
    syntax ValueList ::= List{Value, ","}
    syntax Expression ::= Value

    syntax Type ::= "$selftype"

endmodule

```
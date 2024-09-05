```k

module RUST-VALUE-SYNTAX
    imports BOOL
    imports LIST  // for filling the second argument of `error`.
    imports MAP
    imports MINT
    imports RUST-SHARED-SYNTAX
    imports STRING

    syntax MInt{8}
    syntax MInt{16}
    syntax MInt{32}
    syntax MInt{64}
    syntax MInt{128}

    syntax SemanticsError ::= error(String, KItem)

    syntax Value  ::= i32(MInt{32})
                    | u32(MInt{32})
                    | i64(MInt{64})
                    | u64(MInt{64})
                    | u128(MInt{128})
                    | tuple(ValueList)
                    | struct(TypePath, Map)  // Map from field name (Identifier) to value ID (Int)
                    | Bool

    syntax ValueList ::= List{Value, ","}
    syntax Expression ::= Value
    syntax KResult ::= Value

    syntax ValueOrError ::= Value | SemanticsError

    syntax Bool ::= mayBeDefaultTypedInt(Value)  [function, total]
    rule mayBeDefaultTypedInt(_V) => false  [owise]
    rule mayBeDefaultTypedInt(u128(_)) => true
endmodule

module RUST-REPRESENTATION
    imports INT
    imports RUST-SHARED-SYNTAX
    imports RUST-VALUE-SYNTAX

    syntax FunctionBodyRepresentation ::= block(BlockExpression)
                                        | "empty"
    syntax NormalizedFunctionParameter ::= Identifier ":" Type
    syntax NormalizedFunctionParameterList ::= List{NormalizedFunctionParameter, ","}

    syntax NormalizedCallParams ::=List{Int, ","}

    syntax Instruction  ::= normalizedMethodCall(TypePath, Identifier, NormalizedCallParams)
                          | implicitCastTo(Type)

    syntax NormalizedFunctionParameterListOrError ::= NormalizedFunctionParameterList | SemanticsError

    syntax Type ::= "$selftype"

    syntax Identifier ::= "i32"  [token]
                        | "u32"  [token]
                        | "i64"  [token]
                        | "u64"  [token]
    syntax MaybeIdentifier ::= ".Identifier" | Identifier

endmodule

```

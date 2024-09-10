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
                    | String

    syntax ValueList ::= List{Value, ","}
    syntax ValueOrError ::= Value | SemanticsError

    syntax Ptr ::= "null" | ptr(Int)
    syntax PtrValue ::= ptrValue(Ptr, Value)
    syntax PtrValueOrError ::= PtrValue | SemanticsError

    syntax Expression ::= PtrValue
    syntax KResult ::= PtrValue

    syntax PtrValueOrError ::= wrapPtrValueOrError(Ptr, ValueOrError)  [function, total]
    rule wrapPtrValueOrError(P:Ptr, V:Value) => ptrValue(P, V)
    rule wrapPtrValueOrError(_:Ptr, E:SemanticsError) => E

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
                                        | storageAccessor(StringLiteral)
    syntax ValueName ::= Identifier | SelfSort
    syntax NormalizedFunctionParameter ::= ValueName ":" Type
    syntax NormalizedFunctionParameterList ::= List{NormalizedFunctionParameter, ","}

    syntax NormalizedCallParams ::=List{Ptr, ","}

    syntax Instruction  ::= normalizedMethodCall(TypePath, Identifier, NormalizedCallParams)
                          | implicitCastTo(Type)
                          | methodCall
                              ( self: Expression
                              , method:Identifier
                              , params: CallParamsList
                              )
                            [seqstrict(1, 3), result(ValueWithPtr)]
                          | staticMethodCall
                              ( trait: TypePath
                              , method: Identifier
                              , params: CallParamsList
                              )
                            [strict(3), result(ValueWithPtr)]

    syntax NormalizedFunctionParameterListOrError ::= NormalizedFunctionParameterList | SemanticsError

    syntax Type ::= "$selftype"

    syntax Identifier ::= "i32"  [token]
                        | "u32"  [token]
                        | "i64"  [token]
                        | "u64"  [token]
                        | "bool" [token]
                        
    syntax MaybeIdentifier ::= ".Identifier" | Identifier

    syntax ExpressionOrCallParams ::= Expression | CallParams 

    syntax Bool ::= isConstant(ValueName)  [function, total]
    syntax Bool ::= isLocalVariable(ValueName)  [function, total]
    syntax Bool ::= isValueWithPtr(K)  [function, total, symbol(isValueWithPtr)]

    syntax IntOrError ::= Int | SemanticsError
    syntax IntOrError ::= valueToInteger(Value)  [function, total]
    syntax ValueOrError ::= integerToValue(Int, Type)  [function, total]

endmodule

```

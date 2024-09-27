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
                    | Range
                    | Bool
                    | String
    syntax Range ::= intRange(Value, Value)
    syntax ValueOrError ::= Value | SemanticsError

    syntax ValueList ::= List{Value, ","}
    syntax ValueListOrError ::= ValueList | SemanticsError

    syntax Ptr ::= "null" | ptr(Int)
    syntax PtrValue ::= ptrValue(Ptr, Value)
    syntax PtrValueOrError ::= PtrValue | SemanticsError

    syntax Expression ::= PtrValue
    syntax KResult ::= PtrValue

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

    syntax PtrList ::= List{Ptr, ","}
    syntax PtrListOrError ::= PtrList | SemanticsError

    syntax Instruction  ::= normalizedMethodCall(TypePath, Identifier, PtrList)
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
                          | "Rust#newStruct" "(" type:TypePath "," fields:MapOrError ")"
                          | reverseNormalizeParams
                              ( params: CallParamsList
                              , reversedNormalizedParams: PtrList
                              )
                          | "clearValue"

    syntax PtrList ::= reverse(PtrList, PtrList) [function, total]

    syntax ValueOrError ::= implicitCast(Value, Type) [function, total]

    syntax MapOrError ::= Map | SemanticsError

    syntax Expression ::= Ptr
    syntax ExpressionOrError ::= Expression | SemanticsError

    syntax NormalizedFunctionParameterListOrError ::= NormalizedFunctionParameterList | SemanticsError

    syntax Type ::= "$selftype"

    syntax Identifier ::= "i32"  [token]
                        | "u32"  [token]
                        | "i64"  [token]
                        | "u64"  [token]
                        | "u128"  [token]
                        | "bool" [token]
                        | "str"  [token]

    syntax MaybeIdentifier ::= ".Identifier" | Identifier

    syntax ExpressionOrCallParams ::= Expression | CallParams

    syntax Bool ::= isConstant(ValueName)  [function, total]
    syntax Bool ::= isLocalVariable(ValueName)  [function, total]
    syntax Bool ::= isValueWithPtr(K)  [function, total, symbol(isValueWithPtr)]

    syntax IntOrError ::= Int | SemanticsError
    syntax IntOrError ::= valueToInteger(Value)  [function, total]
    syntax ValueOrError ::= integerToValue(Int, Type)  [function, total]

    syntax String ::= IdentifierToString(Identifier)  [function, total, hook(STRING.token2string)]

    syntax CallParamsList ::= reverse(CallParamsList, CallParamsList)  [function, total]

    syntax Bool ::= checkIntOfType(Value, Type)  [function, total]
                  | checkIntOfSameType(Value, Value) [function, total]

    rule checkIntOfType(u32(_),  u32) => true
    rule checkIntOfType(i32(_),  i32) => true
    rule checkIntOfType(u64(_),  u64) => true
    rule checkIntOfType(i64(_),  i64) => true
    rule checkIntOfType(i64(_),  u128) => true
    rule checkIntOfType(_, _) => false [owise]

    rule checkIntOfSameType(A:Value, B:Value) => checkIntOfType(A,  u32) requires checkIntOfType(B,  u32) 
    rule checkIntOfSameType(A:Value, B:Value) => checkIntOfType(A,  i32) requires checkIntOfType(B,  i32)
    rule checkIntOfSameType(A:Value, B:Value) => checkIntOfType(A,  u64) requires checkIntOfType(B,  u64)
    rule checkIntOfSameType(A:Value, B:Value) => checkIntOfType(A,  i64) requires checkIntOfType(B,  i64)
    rule checkIntOfSameType(A:Value, B:Value) => checkIntOfType(A,  u128) requires checkIntOfType(B,  u128)
    rule checkIntOfSameType(_, _) => false [owise]

    syntax TypePathOrError ::= TypePath | SemanticsError
    syntax TypePathOrError ::= parentTypePath(TypePath)  [function, total]

    syntax IdentifierOrError ::= Identifier | SemanticsError
    syntax IdentifierOrError ::= leafTypePath(TypePath)  [function, total]

    syntax TypePathSegmentsOrError ::= TypePathSegments | SemanticsError

    syntax ExpressionList ::= ".ExpressionList"
                            | Expression "," ExpressionList  [seqstrict, result(ValueWithPtr)]
    syntax InstructionList  ::= evaluate(ExpressionList)  [strict(1), result(ValueWithPtr)]
                              | evaluate(ValueListOrError)
endmodule

```

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
    syntax MInt{160}
    syntax MInt{256}

    syntax SemanticsError ::= error(String, KItem)

    syntax Value  ::= i8(MInt{8})
                    | u8(MInt{8})
                    | i16(MInt{16})
                    | u16(MInt{16})
                    | i32(MInt{32})
                    | u32(MInt{32})
                    | i64(MInt{64})
                    | u64(MInt{64})
                    | u128(MInt{128})
                    // TODO: u160 and u256 are not real Rust types, remove them
                    // after the demo.
                    | u160(MInt{160})
                    | u256(MInt{256})
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
                          | normalizedFunctionCall(PathInExpression, PtrList)
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
                          | functionCall
                              ( function: PathExpression
                              , params: CallParamsList
                              )
                            [strict(2), result(ValueWithPtr)]
                          | "Rust#newStruct" "(" type:TypePath "," fields:MapOrError ")"
                          | reverseNormalizeParams
                              ( params: CallParamsList
                              , reversedNormalizedParams: PtrList
                              )
                          | "clearValue"
                          | tupleExpression(TupleElementsNoEndComma)

    syntax PtrList ::= reverse(PtrList, PtrList) [function, total]

    syntax ValueOrError ::= implicitCast(Value, Type) [function, total]

    syntax MapOrError ::= Map | SemanticsError

    syntax Expression ::= Ptr
    syntax ExpressionOrError ::= v(Expression) | e(SemanticsError)
    syntax KItem ::= unwrap(ExpressionOrError)  [function, total]
    rule unwrap(v(E:Expression)) => E
    rule unwrap(e(E:SemanticsError)) => E

    syntax NormalizedFunctionParameterListOrError ::= NormalizedFunctionParameterList | SemanticsError

    syntax Type ::= "$selftype"

    syntax Identifier ::= "i8"  [token]
                        | "u8"  [token]
                        | "i16"  [token]
                        | "u16"  [token]
                        | "i32"  [token]
                        | "u32"  [token]
                        | "i64"  [token]
                        | "u64"  [token]
                        | "u128"  [token]
                        | "u160"  [token]
                        | "u256"  [token]
                        | "bool" [token]
                        | "str"  [token]

    syntax MaybeIdentifier ::= ".Identifier" | Identifier
    syntax MaybePathInExpression ::= ".PathInExpression" | PathInExpression

    syntax ExpressionOrCallParams ::= Expression | CallParams

    syntax Bool ::= isConstant(ValueName)  [function, total]
    syntax Bool ::= isLocalVariable(ValueName)  [function, total]
    syntax Bool ::= isValueWithPtr(K)  [function, total, symbol(isValueWithPtr)]

    syntax IntOrError ::= Int | SemanticsError
    syntax IntOrError ::= valueToInteger(Value)  [function, total]
    syntax ValueOrError ::= integerToValue(IntOrError, Type)  [function, total]

    syntax StringOrError ::= String | SemanticsError

    syntax String ::= IdentifierToString(Identifier)  [function, total, hook(STRING.token2string)]
    syntax Identifier ::= StringToIdentifier(String)  [function, total, hook(STRING.string2token)]

    syntax CallParamsList ::= reverse(CallParamsList, CallParamsList)  [function, total]

    syntax Bool ::= checkIntOfType(Value, Type)  [function, total]
                  | checkIntOfSameType(Value, Value) [function, total]

    rule checkIntOfType(u8(_),  u8) => true
    rule checkIntOfType(i8(_),  i8) => true
    rule checkIntOfType(u16(_),  u16) => true
    rule checkIntOfType(i16(_),  i16) => true
    rule checkIntOfType(u32(_),  u32) => true
    rule checkIntOfType(i32(_),  i32) => true
    rule checkIntOfType(u64(_),  u64) => true
    rule checkIntOfType(i64(_),  i64) => true
    rule checkIntOfType(u128(_),  u128) => true
    rule checkIntOfType(u160(_),  u160) => true
    rule checkIntOfType(u256(_),  u256) => true
    rule checkIntOfType(_, _) => false [owise]

    rule checkIntOfSameType(A:Value, B:Value) => checkIntOfType(A,  u8) requires checkIntOfType(B,  u8) 
    rule checkIntOfSameType(A:Value, B:Value) => checkIntOfType(A,  i8) requires checkIntOfType(B,  i8)
    rule checkIntOfSameType(A:Value, B:Value) => checkIntOfType(A,  u16) requires checkIntOfType(B,  u16) 
    rule checkIntOfSameType(A:Value, B:Value) => checkIntOfType(A,  i16) requires checkIntOfType(B,  i16)
    rule checkIntOfSameType(A:Value, B:Value) => checkIntOfType(A,  u32) requires checkIntOfType(B,  u32) 
    rule checkIntOfSameType(A:Value, B:Value) => checkIntOfType(A,  i32) requires checkIntOfType(B,  i32)
    rule checkIntOfSameType(A:Value, B:Value) => checkIntOfType(A,  u64) requires checkIntOfType(B,  u64)
    rule checkIntOfSameType(A:Value, B:Value) => checkIntOfType(A,  i64) requires checkIntOfType(B,  i64)
    rule checkIntOfSameType(A:Value, B:Value) => checkIntOfType(A,  u128) requires checkIntOfType(B,  u128)
    rule checkIntOfSameType(A:Value, B:Value) => checkIntOfType(A,  u160) requires checkIntOfType(B,  u160)
    rule checkIntOfSameType(A:Value, B:Value) => checkIntOfType(A,  u256) requires checkIntOfType(B,  u256)
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

    syntax MaybeTypePath ::= ".TypePath" | TypePath

    syntax TypePath ::= append(MaybeTypePath, Identifier)  [function, total]

    syntax NonEmptyStatementsOrError ::= NonEmptyStatements | SemanticsError
    syntax NonEmptyStatements ::= concatNonEmptyStatements(NonEmptyStatements, NonEmptyStatements)  [function, total]

    syntax CallParamsList ::= concatCallParamsList(CallParamsList, CallParamsList)  [function, total]

    syntax Int ::= length(NormalizedFunctionParameterList)  [function, total]
    syntax NormalizedFunctionParameter ::= last(NormalizedFunctionParameter, NormalizedFunctionParameterList)  [function, total]
    syntax NormalizedFunctionParameterList ::= allButLast(NormalizedFunctionParameter, NormalizedFunctionParameterList)  [function, total]

endmodule

```

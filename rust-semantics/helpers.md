```k
module RUST-HELPERS
    imports BOOL
    imports private RUST-REPRESENTATION

    syntax Int ::= paramsLength(NormalizedFunctionParameterList)  [function, total]
    rule paramsLength(.NormalizedFunctionParameterList) => 0
    rule paramsLength(_P:NormalizedFunctionParameter , Ps:NormalizedFunctionParameterList)
        => 1 +Int paramsLength(Ps)

    syntax Bool ::= isSameType(Value, Type)  [function, total]
    rule isSameType(_, _) => false  [owise]
    rule isSameType(_:Value, & T => T)
    rule isSameType(_, $selftype) => true
    rule isSameType(u256(_), u256) => true
    rule isSameType(u160(_), u160) => true
    rule isSameType(u128(_), u128) => true
    rule isSameType(i64(_), i64) => true
    rule isSameType(u64(_), u64) => true
    rule isSameType(i32(_), i32) => true
    rule isSameType(u32(_), u32) => true
    rule isSameType(i16(_), i16) => true
    rule isSameType(u16(_), u16) => true
    rule isSameType(i8(_), i8) => true
    rule isSameType(u8(_), u8) => true
    rule isSameType(_:Bool, bool) => true
    rule isSameType(_:String, str) => true
    rule isSameType(struct(T, _), T:TypePath) => true
    rule isSameType(struct(T, _), T:Identifier _:GenericArgs ) => true

    syntax Bool ::= isUnsignedInt(Type)  [function, total]
    rule isUnsignedInt(_) => false [owise]
    rule isUnsignedInt(u8) => true
    rule isUnsignedInt(u16) => true
    rule isUnsignedInt(u32) => true
    rule isUnsignedInt(u64) => true
    rule isUnsignedInt(u128) => true
    rule isUnsignedInt(u160) => true
    rule isUnsignedInt(u256) => true
    rule isUnsignedInt(&T => T)

    syntax Bool ::= isSignedInt(Type)  [function, total]
    rule isSignedInt(_) => false [owise]
    rule isSignedInt(i8) => true
    rule isSignedInt(i16) => true
    rule isSignedInt(i32) => true
    rule isSignedInt(i64) => true
    rule isSignedInt(&T => T)

    rule concatNonEmptyStatements(.NonEmptyStatements, S:NonEmptyStatements) => S
    rule concatNonEmptyStatements(S:Statement Ss1:NonEmptyStatements, Ss2:NonEmptyStatements)
        => S concatNonEmptyStatements(Ss1, Ss2)
endmodule
```

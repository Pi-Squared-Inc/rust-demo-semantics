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
    rule isSameType(i64(_), i64) => true
    rule isSameType(u64(_), u64) => true
    rule isSameType(i32(_), i32) => true
    rule isSameType(u32(_), u32) => true
    rule isSameType(struct(T, _), T:Type) => true
    rule isSameType(struct(T, _), T:Identifier _:GenericArgs ) => true

endmodule
```

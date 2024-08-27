```k

module RUST-CALLS
    imports BOOL
    imports private COMMON-K-CELL
    imports private RUST-EXECUTION-CONFIGURATION
    imports private RUST-HELPERS
    imports private RUST-PREPROCESSING-CONFIGURATION
    imports private RUST-REPRESENTATION
    imports private RUST-STACK

    // https://doc.rust-lang.org/stable/reference/expressions/method-call-expr.html

    syntax Instruction  ::= "clearLocalState"
                          | setArgs(NormalizedCallParams, NormalizedFunctionParameterList)

    rule
        <k>
            normalizedMethodCall(
                TraitName:TypePath,
                MethodName:Identifier,
                Args:NormalizedCallParams
            ) => pushLocalState
                ~> clearLocalState
                ~> setArgs(Args, Params)
                ~> FunctionBody
                ~> implicitCastTo(ReturnType)
                ~> popLocalState
            ...
        </k>
        <trait-path> TraitName </trait-path>
        <method-name> MethodName </method-name>
        <method-params> Params:NormalizedFunctionParameterList </method-params>
        <method-return-type> ReturnType:Type </method-return-type>
        <method-implementation> block(FunctionBody) </method-implementation>

    rule
        <k>
            clearLocalState => .K
            ...
        </k>
        <locals> _ => .Map </locals>

    rule
        <k>
            setArgs(
                (ValueId:Int , Ids:NormalizedCallParams) => Ids,
                ((Name:Identifier : T:Type) , Ps:NormalizedFunctionParameterList) => Ps
            )
            ...
        </k>
        <locals> Locals:Map => Locals[Name <- ValueId] </locals>
        <values> ValueId |-> Value ... </values>
        requires notBool Name in_keys(Locals) andBool isSameType(Value, T)

    rule setArgs(.NormalizedCallParams, .NormalizedFunctionParameterList) => .K

endmodule

```

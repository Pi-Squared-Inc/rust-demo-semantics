```k

module RUST-CALLS
    imports BOOL
    imports private COMMON-K-CELL
    imports private RUST-CONVERSIONS-SYNTAX
    imports private RUST-EXECUTION-CONFIGURATION
    imports private RUST-HELPERS
    imports private RUST-PREPROCESSING-CONFIGURATION
    imports private RUST-REPRESENTATION
    imports private RUST-STACK

    // https://doc.rust-lang.org/stable/reference/expressions/method-call-expr.html

    syntax Instruction  ::= "clearLocalState"
                          | setArgs(PtrList, NormalizedFunctionParameterList)

    rule normalizedMethodCall(
                TraitName:TypePath,
                MethodName:Identifier,
                Args:PtrList
            )
        => normalizedFunctionCall
            ( typePathToPathInExpression(append(TraitName, MethodName))
            , Args
            )
        [owise]

    rule
        <k>
            normalizedFunctionCall(
                MethodName:PathInExpression,
                Args:PtrList
            ) => pushLocalState
                ~> clearLocalState
                ~> setArgs(Args, Params)
                ~> FunctionBody
                ~> implicitCastTo(ReturnType)
                ~> popLocalState
            ...
        </k>
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

    rule setArgs
            ( (CP:Ptr, CPs:PtrList)
            , (P:NormalizedFunctionParameter, Ps:NormalizedFunctionParameterList)
            )
        => setArg(CP, P) ~> setArgs(CPs, Ps)

    rule setArgs(.PtrList, .NormalizedFunctionParameterList) => .K

    syntax Instruction ::= setArg(Ptr, NormalizedFunctionParameter)

    rule
        <k>
            setArg
                ( ptr(ValueId:Int)
                , Name:ValueName : T:Type
                )
            => .K
            ...
        </k>
        <locals> Locals:Map => Locals[Name <- ValueId] </locals>
        <values> ValueId |-> Value ... </values>
        requires notBool Name in_keys(Locals)
            andBool isSameType(Value, T)

endmodule

```

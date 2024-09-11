```k

module MX-RUST-CALLS-IMPLEMENTATION
    imports private COMMON-K-CELL
    imports private MX-CALL-CONFIGURATION
    imports private MX-COMMON-SYNTAX
    imports private MX-RUST-CALLS-CONFIGURATION
    imports private MX-RUST-REPRESENTATION
    imports private RUST-EXECUTION-CONFIGURATION
    imports private RUST-PREPROCESSING-CONFIGURATION
    imports private RUST-REPRESENTATION
    imports private RUST-SHARED-SYNTAX

    rule (.K => rustValueToMx(V))
        ~> rustValuesToMx((V:Value , L:ValueList => L), _:MxValueList)
    rule (V:MxValue => .K)
        ~> rustValuesToMx(_:ValueList, (L:MxValueList => V , L))
    rule rustValuesToMx(.ValueList, ReversedArgs:MxValueList) ~> Hook:MxHookName
        => Hook(reverse(ReversedArgs, .MxValueList))

    rule
        <k>
            host.pushCallState => .K
            ...
        </k>
        Execution:ExecutionCell
        <rust-execution-state-stack> .List => ListItem(Execution) ... </rust-execution-state-stack>

    rule
        <k>
            host.popCallState => .K
            ...
        </k>
        (_:ExecutionCell => Execution)
        <rust-execution-state-stack> ListItem(Execution:ExecutionCell) => .List ... </rust-execution-state-stack>

    rule
        <k>
            host.resetCallState => .K
            ...
        </k>
        (_:ExecutionCell => <execution>... <values> .Map </values> </execution>)

    rule
        <k>
            host.newEnvironment
                ( rustCode
                    ( EndpointToFunction:Map
                    , TraitName:TypePath
                    , Preprocessed:PreprocessedCell
                    )
                )
            => .K
            ...
        </k>
        <mx-rust-last-trait-name> _ => TraitName </mx-rust-last-trait-name>
        <mx-rust-endpoint-to-function> _ => EndpointToFunction </mx-rust-endpoint-to-function>
        (_:PreprocessedCell => Preprocessed)

    rule
        <k>
            host.mkCall(FunctionName:String)
            => MxRust#newContractObject(TraitName)
                ~> MxRust#partialMethodCall(Endpoint, mxArgsToRustArgs(Args))
            ...
        </k>
        <mx-rust-endpoint-to-function>
            FunctionName |-> Endpoint:Identifier ...
        </mx-rust-endpoint-to-function>
        <mx-rust-last-trait-name>
            TraitName:TypePath
            => (#token("no#path", "Identifier"):Identifier):TypePath
        </mx-rust-last-trait-name>
        <mx-call-args> Args:MxValueList </mx-call-args>

    rule ptrValue(...) #as SelfValue:Expression
        ~> MxRust#partialMethodCall(Method:Identifier, Params:CallParamsList)
        => methodCall(... self: SelfValue, method: Method, params: Params)

    syntax MxRustInstruction ::= "MxRust#newContractObject" "(" TypePath ")"
    rule MxRust#newContractObject(P:TypePath) => Rust#newStruct(P, .Map)

    syntax MxRustInstruction ::= "MxRust#partialMethodCall" "(" Identifier "," CallParamsList ")"

    syntax CallParamsList ::= mxArgsToRustArgs(MxValueList)  [function, total]
    rule mxArgsToRustArgs(.MxValueList) => .CallParamsList

    rule (ptrValue(_, V:Value) => rustValueToMx(V)) ~> endCall

endmodule

```

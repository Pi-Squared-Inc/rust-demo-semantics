```k

module MX-RUST-CALLS-IMPLEMENTATION
    imports private COMMON-K-CELL
    imports private MX-CALL-CONFIGURATION
    imports private MX-COMMON-SYNTAX
    imports private MX-RUST-CALLS-CONFIGURATION
    imports private MX-RUST-PREPROCESSED-ENDPOINTS-CONFIGURATION
    imports private MX-RUST-PREPROCESSED-CONFIGURATION
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
                    ( MxRustPreprocessed:MxRustPreprocessedCell
                    , Preprocessed:PreprocessedCell
                    )
                )
            => .K
            ...
        </k>
        (_:MxRustPreprocessedCell => MxRustPreprocessed)
        (_:PreprocessedCell => Preprocessed)

    rule
        <k>
            host.mkCall(FunctionName:String)
            => MxRust#newContractObject(TraitName)
                ~> mxArgsToRustArgs(Args, Nfp, .CallParamsList)
                ~> MxRust#partialMethodCall(Endpoint)
            ...
        </k>
        <mx-rust-endpoint-to-function>
            FunctionName |-> Endpoint:Identifier ...
        </mx-rust-endpoint-to-function>
        <mx-rust-contract-trait> TraitName:TypePath </mx-rust-contract-trait>
        <mx-call-args> Args:MxValueList </mx-call-args>
        <trait-path> TraitName </trait-path>
        <method-name> Endpoint </method-name>
        <method-params> _:SelfSort : _ , Nfp:NormalizedFunctionParameterList </method-params>

    rule (ptrValue(...) #as SelfValue:Expression) , Params:CallParamsList
        ~> MxRust#partialMethodCall(Method:Identifier)
        => methodCall(... self: SelfValue, method: Method, params: Params)

    syntax MxRustInstruction ::= "MxRust#newContractObject" "(" TypePath ")"
    rule MxRust#newContractObject(P:TypePath) => Rust#newStruct(P, .Map)

    syntax MxRustInstruction ::= "MxRust#partialMethodCall" "(" Identifier ")"

    syntax MxRustInstruction ::= mxArgsToRustArgs
                                    ( MxValueList
                                    , NormalizedFunctionParameterList
                                    , CallParamsList
                                    )
    rule mxArgsToRustArgs(.MxValueList, .NormalizedFunctionParameterList, L:CallParamsList)
        => reverse(L, .CallParamsList)
    rule (.K => mxValueToRust(T, V))
        ~> mxArgsToRustArgs
            ( (V:MxValue , L:MxValueList) => L
            , _ : T:Type , Nfp:NormalizedFunctionParameterList => Nfp
            , _:CallParamsList
            )
    rule (V:PtrValue => .K)
        ~> mxArgsToRustArgs
            ( _:MxValueList
            , _:NormalizedFunctionParameterList
            , L:CallParamsList => V, L
            )

    rule (ptrValue(_, V:Value) => rustValueToMx(V)) ~> endCall

endmodule

```

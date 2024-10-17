```k

module UKM-TEST-SYNTAX
    imports INT-SYNTAX
    imports RUST-EXECUTION-TEST-PARSING-SYNTAX
    imports UKM-HOOKS-UKM-SYNTAX

    syntax ExecutionItem  ::= "mock" "CallData"
                            | "mock" "Caller"
                            | "mock" UkmHook UkmHookResult
                            | "call_contract" Int
                            | "output_to_arg"
                            | "push_status"
                            | "check_eq" Int
endmodule

module UKM-TEST-EXECUTION
    imports private COMMON-K-CELL
    imports private RUST-EXECUTION-TEST-CONFIGURATION
    imports private UKM-EXECUTION-SYNTAX
    imports private UKM-HOOKS-BYTES-CONFIGURATION
    imports private UKM-HOOKS-BYTES-SYNTAX
    imports private UKM-HOOKS-STATE-CONFIGURATION
    imports private UKM-HOOKS-UKM-SYNTAX
    imports private UKM-TEST-SYNTAX

    syntax Mockable ::= UkmHook

    rule
        <k> mock CallData => mock(CallDataHook(), V) ... </k>
        <test-stack>
            (ListItem(ptrValue(_, u64(_BytesId)) #as V:PtrValue) => .List)
            ...
        </test-stack>

    rule
        <k> mock Caller => mock(CallerHook(), V) ... </k>
        <test-stack>
            (ListItem(ptrValue(_, u64(_BytesId)) #as V:PtrValue) => .List)
            ...
        </test-stack>

    rule mock Hook:UkmHook Result:UkmHookResult => mock(Hook, Result)

    rule call_contract Account => ukmExecute(Account, 100)

    rule
        <k>
            output_to_arg => ukmBytesNew(Output) ~> return_value_to_arg
            ...
        </k>
        <ukm-output>
            Output:Bytes
        </ukm-output>

    rule
        <k>
            push_status => .K
            ...
        </k>
        <ukm-status>
            Status:Int
        </ukm-status>
        <test-stack>
            .List => ListItem(Status)
            ...
        </test-stack>

    rule
        <k> check_eq I:Int => .K ... </k>
        <test-stack> ListItem(I) => .List ... </test-stack>
endmodule

```

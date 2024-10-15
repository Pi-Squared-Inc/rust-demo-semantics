```k

requires "blockchain-k-plugin/plugin/krypto.md"

module UKM-TEST-SYNTAX
    imports INT-SYNTAX
    imports RUST-EXECUTION-TEST-PARSING-SYNTAX

    syntax MockOptions ::= "CallData"
                        | "EncodeFunctionCall"

    syntax ExecutionItem  ::= "mock" MockOptions
                            | "load_values_for_encoding" List
                            | "encode_function_signature1" List
                            | "encode_function_signature2" List
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
    imports STRING
    imports BYTES
    imports KRYPTO

    rule 
        <k> mock EncodeFunctionCall => load_values_for_encoding L ~> encode_function_signature1 .List ... </k>
        <test-stack>
            L:List => .List
        </test-stack>

    rule 
        <k> load_values_for_encoding ListItem(PTR) L:List 
                ~> encode_function_signature1 LoadedList 
                => PTR ~> load_values_for_encoding L ~> encode_function_signature1 LoadedList 
            ... 
        </k>
        
    rule 
        <k> PV:PtrValue ~> load_values_for_encoding L:List 
                ~> encode_function_signature1 LoadedList 
                => load_values_for_encoding L ~> encode_function_signature1 ListItem(PV) LoadedList 
            ... 
        </k>

    rule <k> load_values_for_encoding .List => .K ... </k>

    rule <k> encode_function_signature1 ListItem(ptrValue(_, FuncName:String)) RL:List => encode_function_signature2 RL ~> FuncName +String "(" ... </k>


    rule <k> encode_function_signature2 ListItem(ptrValue(_, FuncParam:String)) RL:List ~> FS:String => encode_function_signature2 RL ~> FS +String FuncParam ... </k>

    rule <k> encode_function_signature2 .List ~> FS:String => Keccak256(String2Bytes(FS +String ")")) ... </k>

    //substrString(Keccak256(String2Bytes(#generateSignature(FNAME, ARGS))), 0, 8)


    rule
        <k> mock CallData => mock(CallDataHook(), V) ... </k>
        <test-stack>
            (ListItem(ptrValue(_, u64(_BytesId)) #as V:PtrValue) => .List)
            ...
        </test-stack>

    rule
        <k> mock CallData => mock(CallDataHook(), V) ... </k>
        <test-stack>
            (ListItem(ptrValue(_, u64(_BytesId)) #as V:PtrValue) => .List)
            ...
        </test-stack>

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

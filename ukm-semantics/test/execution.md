```k

module UKM-TEST-SYNTAX
    imports BYTES-SYNTAX
    imports INT-SYNTAX
    imports STRING-SYNTAX
    imports RUST-EXECUTION-TEST-PARSING-SYNTAX
    imports UKM-HOOKS-UKM-SYNTAX
    imports BYTES-SYNTAX

    // TODO: Do not use KItem for ptr_holder and value_holder. This is
    // too generic and can lead to problems.
    // TODO: Replace the list_ptrs_holder and list_values_holder with
    // PtrList and ValueList.
    syntax UKMTestTypeHolder ::= "ptr_holder" KItem [strict]
                                | "value_holder" KItem
                                | "list_ptrs_holder" List
                                | "list_values_holder" List

    syntax UKMTestTypeHolderList ::= List{UKMTestTypeHolder, ","}

    syntax ExecutionItem  ::= "mock" "CallData"
                            | "mock" "Caller"
                            | "mock" UkmHook UkmHookResult
                            | "list_mock" UkmHook UkmHookResult
                            | "encode_call_data"
                            | "encode_call_data_to_string"
                            | "encode_constructor_data"
                            | "call_contract" Int
                            | "init_contract" Int
                            | "clear_pgm"
                            | "hold" KItem 
                            | "output_to_arg"
                            | "push_status"
                            | "check_eq" Int
                            | "hold_string_from_test_stack"
                            | "hold_list_values_from_test_stack"
                            | "expect_cancel"

    syntax Identifier ::= "u8"  [token]
                        | "u16"  [token]
                        | "u32"  [token]
                        | "u64"  [token]
                        | "u128"  [token]
                        | "u160"  [token]
                        | "u256"  [token]
endmodule

module UKM-TEST-EXECUTION
    imports private BYTES
    imports private COMMON-K-CELL
    imports private RUST-EXECUTION-TEST-CONFIGURATION
    imports private RUST-SHARED-SYNTAX
    imports private UKM-ENCODING-SYNTAX
    imports private UKM-EXECUTION-SYNTAX
    imports private UKM-HOOKS-BYTES-CONFIGURATION
    imports private UKM-HOOKS-HELPERS-SYNTAX
    imports private UKM-HOOKS-STATE-CONFIGURATION
    imports private UKM-HOOKS-UKM-SYNTAX
    imports private UKM-REPRESENTATION
    imports private UKM-TEST-SYNTAX
    imports private RUST-SHARED-SYNTAX
    imports private BYTES

    syntax Mockable ::= UkmHook

    // The following constructions allows us to build more complex data structures
    // for mocking tests
    rule <k> UTH:UKMTestTypeHolder ~> EI:ExecutionItem => EI ~> UTH ... </k>
    rule <k> UTHL:UKMTestTypeHolderList ~> EI:ExecutionItem => EI ~> UTHL ... </k>
    rule <k> UTH1:UKMTestTypeHolder ~> UTH2:UKMTestTypeHolder 
                => (UTH1, UTH2):UKMTestTypeHolderList ... </k> 
    rule <k> UTH:UKMTestTypeHolder ~> UTHL:UKMTestTypeHolderList 
                => (UTH, UTHL):UKMTestTypeHolderList ... </k> 

    rule <k> hold_string_from_test_stack => ptr_holder P ... </k>
         <test-stack> ListItem(P) L:List => L </test-stack>
    rule <k> ptr_holder ptrValue(_, V) => value_holder V ... </k>
    

    // TODO: Rework the implementation of the productions related to list value holding
    // Ref - https://github.com/Pi-Squared-Inc/rust-demo-semantics/pull/167#discussion_r1813386536
    rule <k> hold_list_values_from_test_stack => list_ptrs_holder L ~> list_values_holder .List ... </k>
         <test-stack> L:List => .List </test-stack>
    rule <k> list_ptrs_holder ListItem(I) LPH ~> list_values_holder LLH   
                => I ~> list_ptrs_holder LPH ~> list_values_holder LLH ... </k> 
    rule <k> ptrValue(_, V) ~> list_ptrs_holder LPH ~> list_values_holder LLH
                => list_ptrs_holder LPH ~> list_values_holder ListItem(V) LLH ... </k> 
    rule <k> list_ptrs_holder .List => .K ... </k>

    rule <k> hold I => value_holder I ... </k>

    rule <k> encode_call_data_to_string
             ~> list_values_holder ARGS , list_values_holder PTYPES , value_holder FNAME , .UKMTestTypeHolderList
             => Bytes2String(encodeCallData(FNAME, PTYPES, ARGS)) 
            ...
         </k> 
    
    rule <k> encode_call_data_to_string
             ~> value_holder FNAME 
             => Bytes2String(encodeCallData(FNAME, .List, .List)) 
            ...
         </k> [owise]

    rule <k> encode_call_data
             ~> list_values_holder ARGS , list_values_holder PTYPES , value_holder FNAME , .UKMTestTypeHolderList
             => ukmBytesNew(encodeCallData(FNAME, PTYPES, ARGS)) 
            ...
         </k> 

    rule <k> encode_call_data
             ~> value_holder FNAME
             => ukmBytesNew(encodeCallData(FNAME, .List, .List)) 
            ...
         </k> [owise]

    rule <k> encode_constructor_data
             ~> list_values_holder ARGS , list_values_holder PTYPES , .UKMTestTypeHolderList
             => ukmBytesNew(encodeConstructorData(PTYPES, ARGS)) 
            ...
         </k> 

    rule <k> encode_constructor_data
             => ukmBytesNew(encodeConstructorData(.List, .List)) 
            ...
         </k> [owise]

    rule
        <k> mock CallData => mock(CallDataHook(), V) ... </k>
        <test-stack>
            (ListItem(ptrValue(_, u64(_BytesId)) #as V:PtrValue) => .List)
            ...
        </test-stack>

    rule
        <k> mock Caller => mock(CallerHook(), V) ... </k>
        <test-stack>
            (ListItem(ptrValue(_, u160(_AccountId)) #as V:PtrValue) => .List)
            ...
        </test-stack>

    rule mock Hook:UkmHook Result:UkmHookResult => mock(Hook, Result)
    rule list_mock Hook:UkmHook Result:UkmHookResult => listMock(Hook, Result)

    rule call_contract Account => ukmExecute(false, .Bytes, Account, 100)

    rule init_contract Account => ukmExecute(true, b"init", Account, 100)

    rule (V:PtrValue ~> b"init" ~> clear_pgm) => V

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

    rule (ukmCancel ~> expect_cancel) => .K

endmodule

```

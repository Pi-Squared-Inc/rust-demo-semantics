```k

module ULM-TEST-SYNTAX
    imports BYTES-SYNTAX
    imports INT-SYNTAX
    imports STRING-SYNTAX
    imports RUST-EXECUTION-TEST-PARSING-SYNTAX
    imports ULM-SEMANTICS-HOOKS-ULM-SYNTAX
    imports BYTES-SYNTAX

    // TODO: Replace the list_ptrs_holder and list_values_holder with
    // PtrList and ValueList.
    syntax ULMTestTypeHolder ::=  "list_ptrs_holder" List
                                | "list_values_holder" List

    syntax ULMTestTypeHolderList ::= List{ULMTestTypeHolder, ","}
    syntax BytesList ::= NeList{Bytes, "+"}

    syntax EncodeArg ::= Expression ":" Type
    syntax EncodeArgs ::= List{EncodeArg, ","}
    syntax EncodeCall ::= Identifier "(" EncodeArgs ")"

    syntax Expression ::= newBytes(Bytes)

    syntax ExecutionItem  ::= "mock" "CallData"
                            | "mock" "Caller"
                            | "mock" UlmHook UlmHookResult
                            | "list_mock" UlmHook UlmHookResult
                            | "encode_call_data" EncodeCall
                            | "encode_constructor_data" EncodeArgs
                            | "call_contract" Int
                            | "init_contract" Int
                            | "clear_pgm"
                            | "output_to_arg"
                            | "push_status"
                            | "check_eq" Int
                            | "hold_list_values_from_test_stack"
                            | "expect_cancel"
                            | "check_raw_output" BytesList
                            | "check_eq_bytes" Bytes

    syntax Identifier ::= "u8"  [token]
                        | "u16"  [token]
                        | "u32"  [token]
                        | "u64"  [token]
                        | "u128"  [token]
                        | "u160"  [token]
                        | "u256"  [token]
endmodule

module ULM-TEST-EXECUTION
    imports private BYTES
    imports private COMMON-K-CELL
    imports private K-EQUAL-SYNTAX
    imports private RUST-ERROR-SYNTAX
    imports private RUST-EXECUTION-TEST-CONFIGURATION
    imports private RUST-SHARED-SYNTAX
    imports private ULM-ENCODING-SYNTAX
    imports private ULM-EXECUTION-SYNTAX
    imports private ULM-SEMANTICS-HOOKS-BYTES-CONFIGURATION
    imports private ULM-SEMANTICS-HOOKS-HELPERS-SYNTAX
    imports private ULM-SEMANTICS-HOOKS-STATE-CONFIGURATION
    imports private ULM-SEMANTICS-HOOKS-ULM-SYNTAX
    imports private ULM-REPRESENTATION
    imports private ULM-TEST-SYNTAX

    syntax Mockable ::= UlmHook

    // The following constructions allows us to build more complex data structures
    // for mocking tests
    rule <k> UTH:ULMTestTypeHolder ~> EI:ExecutionItem => EI ~> UTH ... </k>
    rule <k> UTHL:ULMTestTypeHolderList ~> EI:ExecutionItem => EI ~> UTHL ... </k>
    rule <k> UTH1:ULMTestTypeHolder ~> UTH2:ULMTestTypeHolder
                => (UTH1, UTH2):ULMTestTypeHolderList ... </k>
    rule <k> UTH:ULMTestTypeHolder ~> UTHL:ULMTestTypeHolderList
                => (UTH, UTHL):ULMTestTypeHolderList ... </k>

    // TODO: Rework the implementation of the productions related to list value holding
    // Ref - https://github.com/Pi-Squared-Inc/rust-demo-semantics/pull/167#discussion_r1813386536
    rule <k> hold_list_values_from_test_stack => list_ptrs_holder L ~> list_values_holder .List ... </k>
         <test-stack> L:List => .List </test-stack>
    rule <k> list_ptrs_holder ListItem(I) LPH ~> list_values_holder LLH
                => I ~> list_ptrs_holder LPH ~> list_values_holder LLH ... </k>
    rule <k> ptrValue(_, V) ~> list_ptrs_holder LPH ~> list_values_holder LLH
                => list_ptrs_holder LPH ~> list_values_holder ListItem(V) LLH ... </k>
    rule <k> list_ptrs_holder .List => .K ... </k>

    syntax BytesOrError ::= extractCallSignature(EncodeCall)  [function, total]
    rule extractCallSignature(Fn:Identifier ( Args:EncodeArgs ))
        => methodSignature(IdentifierToString(Fn), encodeArgsToNormalizedParams(Args))
    syntax NormalizedFunctionParameterList ::= encodeArgsToNormalizedParams(EncodeArgs)  [function, total]
    rule encodeArgsToNormalizedParams(.EncodeArgs) => .NormalizedFunctionParameterList
    rule encodeArgsToNormalizedParams(_:Expression : T:Type ,  Eas:EncodeArgs )
        => #token("#unused", "Identifier"):T , encodeArgsToNormalizedParams(Eas)

    syntax Identifier ::= "append_bytes_raw"  [token]
                        | "buffer_id"  [token]
                        | "bytes_hooks"  [token]
                        | "empty"  [token]

    syntax EncodeValues ::= encodeArgsToEncodeValues(EncodeArgs)  [function, total]
    rule encodeArgsToEncodeValues(.EncodeArgs) => .EncodeValues
    rule encodeArgsToEncodeValues(E:Expression : T:Type , Es:EncodeArgs)
        => E : T , encodeArgsToEncodeValues(Es)

    syntax NonEmptyStatementsOrError ::= encodeInstructions(EncodeCall)  [function, total]
    rule encodeInstructions( _:Identifier ( Args:EncodeArgs ) )
        => encodeInstructions(Args)
    syntax NonEmptyStatementsOrError ::= encodeInstructions(EncodeArgs)  [function, total]
    rule encodeInstructions(Args:EncodeArgs)
        => concat
            (   let buffer_id = :: bytes_hooks :: empty( .CallParamsList );
                .NonEmptyStatements
            ,   encodeStatements(buffer_id, encodeArgsToEncodeValues(Args))
            )

    rule encode_call_data C:EncodeCall
        => encodeCallData(extractCallSignature(C), encodeInstructions(C))

    syntax ExecutionItem ::= encodeCallData(BytesOrError, NonEmptyStatementsOrError)
    rule encodeCallData(Signature:Bytes, Statements:NonEmptyStatements)
        =>  Statements
            :: bytes_hooks :: append_bytes_raw
                ( ulmBytesNew(Signature) , buffer_id , .CallParamsList ):Expression

    rule
        <k>
            check_eq_bytes B:Bytes => .K
            ...
        </k>
        <test-stack>
            ListItem(ptrValue(_, u64(V))) => .List
            ...
        </test-stack>
        <ulm-bytes-buffers>
            Buffers:Map
        </ulm-bytes-buffers>
        requires B:Bytes:KItem ==K Buffers[MInt2Unsigned(V)] orDefault 0

    syntax ExecutionItem ::= encodeConstructorData(NonEmptyStatementsOrError)

    rule encode_constructor_data Args:EncodeArgs
        => encodeConstructorData(encodeInstructions(Args))
    rule encodeConstructorData(Statements:NonEmptyStatements)
        =>  Statements
            buffer_id:Expression

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

    rule mock Hook:UlmHook Result:UlmHookResult => mock(Hook, Result)
    rule list_mock Hook:UlmHook Result:UlmHookResult => listMock(Hook, Result)

    rule call_contract Account => ulmExecute(false, .Bytes, Account, 100)

    rule init_contract Account => ulmExecute(true, b"init", Account, 100)

    rule
        <k> clear_pgm => .K ... </k>
        <ulm-output> _ => .Bytes </ulm-output>

    rule
        <k>
            output_to_arg => ulmBytesNew(Output) ~> return_value_to_arg
            ...
        </k>
        <ulm-output>
            Output:Bytes
        </ulm-output>

    rule
        <k>
            push_status => .K
            ...
        </k>
        <ulm-status>
            Status:Int
        </ulm-status>
        <test-stack>
            .List => ListItem(Status)
            ...
        </test-stack>

    rule
        <k> check_eq I:Int => .K ... </k>
        <test-stack> ListItem(I) => .List ... </test-stack>

    rule (ulmCancel ~> expect_cancel) => .K

    // BytesList is used to define bytes concatenation in tests, so the "+"
    // uses below represent the test AST concatenation, which we are
    // evaluating by concatenating the bytes.
    syntax Bytes ::= concat(BytesList)  [function, total]
    rule concat(.BytesList) => b""
    rule concat(B:Bytes + Bs:BytesList) => B +Bytes concat(Bs)

    syntax Int ::= size(BytesList)  [function, total]
    rule size(.BytesList) => 0
    rule size(_:Bytes + Bs:BytesList) => 1 +Int size(Bs)

    rule check_raw_output (L:BytesList => concat(L) + .BytesList)
        requires size(L) >Int 1
    rule
        <k>
            check_raw_output B:Bytes + .BytesList => .K
            ...
        </k>
        <ulm-output> B:Bytes </ulm-output>

endmodule

```

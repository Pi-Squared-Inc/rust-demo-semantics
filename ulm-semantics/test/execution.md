```k

module ULM-TEST-SYNTAX
    imports BYTES-SYNTAX
    imports INT-SYNTAX
    imports RUST-EXECUTION-TEST-PARSING-SYNTAX
    imports STRING-SYNTAX
    imports ULM-ENCODING-ENCODE-VALUE-SYNTAX
    imports ULM-SEMANTICS-HOOKS-ULM-SYNTAX

    syntax BytesList ::= NeList{Bytes, "+"}

    syntax EncodeCall ::= Identifier "(" EncodeValues ")"

    syntax Expression ::= newBytes(Bytes)

    syntax ExecutionItem  ::= "mock" "CallData"
                            | "mock" "Caller"
                            | "mock" UlmHook UlmHookResult
                            | "mock" UlmTestHook UlmHookResult  [strict(1), result(TestResult)]
                            | "list_mock" UlmHook UlmHookResult
                            | "list_mock" UlmTestHook UlmHookResult  [strict(1), result(TestResult)]
                            | "encode_call_data" EncodeCall
                            | "encode_constructor_data" EncodeValues
                            | "call_contract" Int
                            | "init_contract" Int
                            | "clear_pgm"
                            | "output_to_arg"
                            | "push_status"
                            | "check_eq" Int
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

    syntax UlmTestHook  ::= SetAccountStorageHook(StorageKey, Expression)  [seqstrict, result(TestResult)]
                          | GetAccountStorageHook(StorageKey)  [seqstrict, result(TestResult)]
                          | Log3Hook(EventSignature, Int, Int, EncodeValues)  [seqstrict(1, 4), result(TestResult)]

    syntax StorageKey ::= storageKey(String, EncodeValues)
    syntax EventSignature ::= eventSignature(String)
    syntax EncodeValues ::= encodeValues(EncodeValues)
endmodule

module ULM-TEST-EXECUTION
    imports private BYTES
    imports private COMMON-K-CELL
    imports private K-EQUAL-SYNTAX
    imports private KRYPTO
    imports private RUST-ERROR-SYNTAX
    imports private RUST-EXECUTION-TEST-CONFIGURATION
    imports private RUST-REPRESENTATION
    imports private RUST-SHARED-SYNTAX
    imports private ULM-ENCODING-SYNTAX
    imports private ULM-EXECUTION-SYNTAX
    imports private ULM-SEMANTICS-HOOKS-BYTES-CONFIGURATION
    imports private ULM-SEMANTICS-HOOKS-HELPERS-SYNTAX
    imports private ULM-SEMANTICS-HOOKS-STATE-CONFIGURATION
    imports private ULM-SEMANTICS-HOOKS-ULM-SYNTAX
    imports private ULM-REPRESENTATION
    imports private ULM-TEST-SYNTAX

    syntax UlmTestHook  ::= mockSetAccountStorageHook(Int, IntOrError)
                          | mockGetAccountStorageHook(Int)
                          | #Log3Hook(Int, Int, Int, Bytes)
    syntax Mockable ::= UlmHook

    syntax BytesOrError ::= extractCallSignature(EncodeCall)  [function, total]
    rule extractCallSignature(Fn:Identifier ( Args:EncodeValues ))
        => methodSignature(IdentifierToString(Fn), encodeArgsToNormalizedParams(Args))
    syntax NormalizedFunctionParameterList ::= encodeArgsToNormalizedParams(EncodeValues)  [function, total]
    rule encodeArgsToNormalizedParams(.EncodeValues) => .NormalizedFunctionParameterList
    rule encodeArgsToNormalizedParams(_:Expression : T:Type ,  Eas:EncodeValues )
        => #token("#unused", "Identifier"):T , encodeArgsToNormalizedParams(Eas)

    syntax Identifier ::= "append_bytes_raw"  [token]
                        | "buffer_id"  [token]
                        | "bytes_hooks"  [token]
                        | "empty"  [token]
                        | "str"  [token]

    syntax NonEmptyStatementsOrError ::= encodeInstructions(EncodeCall)  [function, total]
    rule encodeInstructions( _:Identifier ( Args:EncodeValues ) )
        => encodeInstructions(Args)
    syntax NonEmptyStatementsOrError ::= encodeInstructions(EncodeValues)  [function, total]
    rule encodeInstructions(Args:EncodeValues)
        => concat
            (   let buffer_id = :: bytes_hooks :: empty( .CallParamsList );
                .NonEmptyStatements
            ,   codegenValuesEncoder(buffer_id, Args)
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
        // We expect that the item at the top of the stack points to the
        // bytes provided to `check_eq_bytes`. This means that the
        // equality below should evaluate to false on the "orDefault" case
        // (i.e. the item at the top of the stack does not point to bytes).
        requires B:Bytes:KItem ==K Buffers[MInt2Unsigned(V)] orDefault 0

    syntax ExecutionItem ::= encodeConstructorData(NonEmptyStatementsOrError)

    rule encode_constructor_data Args:EncodeValues
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

    syntax Bool ::= isTestResult(K) [symbol(isTestResult), function]
    rule isTestResult(_:K) => false  [owise]
    rule isTestResult(evaluatedStorageKey(_:Bytes)) => true
    rule isTestResult(evaluatedEventSignature(_:Int)) => true
    rule isTestResult(encodedValues(_:Bytes)) => true
    rule isTestResult(_:PtrValue) => true
    rule isTestResult(mockSetAccountStorageHook(_:Int, _:Int)) => true
    rule isTestResult(mockGetAccountStorageHook(_:Int)) => true
    rule isTestResult(#Log3Hook(_:Int, _:Int, _:Int, _:Bytes)) => true

    syntax StorageKey ::= storageKey(NonEmptyStatementsOrError)
                        | storageKey(Expression)  [strict(1)]
                        | storageKey(UlmExpression)  [strict(1)]
                        | evaluatedStorageKey(Bytes)
    rule storageKey(StorageName:String, Args:EncodeValues)
        => storageKey
            ( concat
                (   let buffer_id = :: bytes_hooks :: empty( .CallParamsList );
                    .NonEmptyStatements
                ,   codegenValuesEncoder
                        ( buffer_id
                        , (StorageName : str , Args)
                        )
                )
            )
    rule storageKey(Statements:NonEmptyStatements)
        =>  storageKey({.InnerAttributes Statements buffer_id })
    rule storageKey(ptrValue(_, u64(BytesId))) => storageKey(ulmBytesId(BytesId))
    rule storageKey(ulmBytesValue(B:Bytes)) => evaluatedStorageKey(B)

    syntax EventSignature ::= evaluatedEventSignature(Int)
    rule eventSignature(Signature:String)
        => evaluatedEventSignature(Bytes2Int(Keccak256raw(String2Bytes(Signature)), BE, Unsigned))

    syntax EncodeValues ::= encodeValues(NonEmptyStatementsOrError)
                          | encodeValues(Expression)  [strict(1)]
                          | encodeValues(UlmExpression)  [strict(1)]
                          | encodedValues(Bytes)
    rule encodeValues(Args:EncodeValues)
        => encodeValues
            ( concat
                (   let buffer_id = :: bytes_hooks :: empty( .CallParamsList );
                    .NonEmptyStatements
                ,   codegenValuesEncoder
                        ( buffer_id
                        , Args
                        )
                )
            )
    rule encodeValues(Statements:NonEmptyStatements)
        =>  encodeValues({.InnerAttributes Statements buffer_id })
    rule encodeValues(ptrValue(_, u64(BytesId))) => encodeValues(ulmBytesId(BytesId))
    rule encodeValues(ulmBytesValue(B:Bytes)) => encodedValues(B)

    rule SetAccountStorageHook(evaluatedStorageKey(B:Bytes), ptrValue(_, Value:Value))
        => mockSetAccountStorageHook
                ( Bytes2Int(Keccak256raw(B), BE, Unsigned)
                , valueToInteger(Value)
                )
    rule mock mockSetAccountStorageHook(Key:Int, Value:Int) Result:UlmHookResult
        => mock
            SetAccountStorageHook(Key, Value)
            Result
    rule list_mock mockSetAccountStorageHook(Key:Int, Value:Int) Result:UlmHookResult
        => list_mock
            SetAccountStorageHook(Key, Value)
            Result

    rule GetAccountStorageHook(evaluatedStorageKey(B:Bytes))
        => mockGetAccountStorageHook(Bytes2Int(Keccak256raw(B), BE, Unsigned))
    rule mock mockGetAccountStorageHook(Key:Int) Result:UlmHookResult
        => mock
            GetAccountStorageHook(Key)
            Result
    rule list_mock mockGetAccountStorageHook(Key:Int) Result:UlmHookResult
        => list_mock
            GetAccountStorageHook(Key)
            Result

    rule Log3Hook(evaluatedEventSignature(I:Int), A:Int, C:Int, encodedValues(B2:Bytes))
        => #Log3Hook
                ( I
                , A
                , C
                , B2
                )
    rule list_mock #Log3Hook(V1:Int, V2:Int, V3:Int, B:Bytes) Result:UlmHookResult
        => list_mock
            Log3Hook(V1, V2, V3, B)
            Result

    // This may seem stupid, but it's a workaround for
    // https://github.com/runtimeverification/k/issues/4683
    rule isKResult(X) => true requires isTestResult(X)
endmodule

```

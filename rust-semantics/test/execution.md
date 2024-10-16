```k

module RUST-EXECUTION-TEST-PARSING-SYNTAX
    imports RUST-SHARED-SYNTAX
    imports RUST-VALUE-SYNTAX

    syntax ExecutionTest ::= NeList{ExecutionItem, ";"}
    // syntax ExecutionTest ::= ExecutionItem ";" ExecutionItem
    syntax ExecutionItem  ::= "new" TypePath
                            | "call" TypePath "." Identifier
                            | "call" PathInExpression
                            | "return_value"
                            | "return_value_to_arg"
                            | "check_eq" Expression  [strict]
                            | "push" Expression [strict]
                            | "push_value" Expression [strict]
    syntax KItem ::= mock(KItem, K)
endmodule

module RUST-EXECUTION-TEST
    imports private COMMON-K-CELL
    imports private LIST
    imports private RUST-CONVERSIONS-SYNTAX
    imports private RUST-EXECUTION-CONFIGURATION
    imports private RUST-EXECUTION-TEST-PARSING-SYNTAX
    imports private RUST-EXECUTION-TEST-CONFIGURATION
    imports private RUST-HELPERS
    imports private RUST-PREPROCESSING-CONFIGURATION
    imports private RUST-REPRESENTATION

    rule Es:ExecutionTest => rustChainTest(Es)

    syntax K ::= rustChainTest(ExecutionTest)  [function, total]
    rule rustChainTest(.ExecutionTest) => .K
    rule rustChainTest(I:ExecutionItem ; Is:ExecutionTest) => I ~> rustChainTest(Is)

    rule
        <k>
            (.K => Rust#newStruct(P, .Map))
            ~> new P:TypePath
            ...
        </k>
        <trait-path> P </trait-path>

    rule
        <k> ptrValue(P:Ptr, _:Value) ~> new _:TypePath => .K ... </k>
        <test-stack> .List => ListItem(P) ... </test-stack>

    rule call P:TypePath . Name:Identifier => call typePathToPathInExpression(append(P, Name))

    rule
        <k>
            call Name:PathInExpression
            => buildTestMethodCall(Name, .PtrList, paramsLength(Params))
            ...
        </k>
        <method-name> Name </method-name>
        <method-params> Params </method-params>

    syntax TestExecution ::= buildTestMethodCall(PathInExpression, PtrList, Int)

    rule
        <k>
            buildTestMethodCall(
                _MethodName:PathInExpression,
                Args:PtrList => (ValueId , Args),
                ParamCount:Int => ParamCount -Int 1
            )
            ...
        </k>
        <test-stack> ListItem(ValueId) => .List ... </test-stack>
        requires ParamCount >Int 0

    rule
        buildTestMethodCall(
            MethodName:PathInExpression,
            Args:PtrList,
            0
        ) => normalizedFunctionCall(MethodName, Args)

    rule
        <k> (V:PtrValue ~> return_value) => .K ... </k>
        <test-stack> .List => ListItem(V) ... </test-stack>

    rule (V:PtrValue ~> return_value_to_arg) => push V

    rule
        <k> check_eq ptrValue(_, V:Value) => .K ... </k>
        <test-stack> ListItem(ptrValue(_, V)) => .List ... </test-stack>

    rule
        <k> push ptrValue(_, V:Value) => .K ... </k>
        <test-stack> .List => ListItem(ptr(NVI)) ... </test-stack>
        <values> VALUES:Map => VALUES[NVI <- V] </values>
        <next-value-id> NVI:Int => NVI +Int 1 </next-value-id>

    rule
        <k> push_value ptrValue(_, V:Value) => .K ... </k>
        <test-stack> .List => ListItem(ptrValue(ptr(NVI), V)) ... </test-stack>
        <values> VALUES:Map => VALUES[NVI <- V] </values>
        <next-value-id> NVI:Int => NVI +Int 1 </next-value-id>

    syntax KItem ::= wrappedK(K)
    syntax Mockable

    rule
        <k> mock(Mocked:Mockable, Result:K) => .K ... </k>
        <mocks> M:Map => M[Mocked <- wrappedK(Result)] </mocks>

    rule
        <k> (Mocked:Mockable => Result) ...</k>
        <mocks> Mocked |-> wrappedK(Result:K) ...</mocks>
        [priority(10)]
endmodule

```

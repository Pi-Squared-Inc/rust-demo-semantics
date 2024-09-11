```k

module RUST-EXECUTION-TEST-PARSING-SYNTAX
    imports RUST-SHARED-SYNTAX
    imports RUST-VALUE-SYNTAX

    syntax ExecutionTest ::= NeList{ExecutionItem, ";"}
    // syntax ExecutionTest ::= ExecutionItem ";" ExecutionItem
    syntax ExecutionItem  ::= "new" TypePath
                            | "call" TypePath "." Identifier
                            | "return_value"
                            | "check_eq" Expression  [strict]
                            | "push" Expression [strict]
endmodule

module RUST-EXECUTION-TEST
    imports private COMMON-K-CELL
    imports private LIST
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

    rule
        <k>
            call P:TypePath . Name:Identifier
            => buildTestMethodCall(P, Name, .NormalizedCallParams, paramsLength(Params))
            ...
        </k>
        <trait-path> P </trait-path>
        <method-name> Name </method-name>
        <method-params> Params </method-params>

    syntax TestExecution ::= buildTestMethodCall(TypePath, Identifier, NormalizedCallParams, Int)

    rule
        <k>
            buildTestMethodCall(
                _TraitName:TypePath,
                _MethodName:Identifier,
                Args:NormalizedCallParams => (ValueId , Args),
                ParamCount:Int => ParamCount -Int 1
            )
            ...
        </k>
        <test-stack> ListItem(ValueId) => .List ... </test-stack>
        requires ParamCount >Int 0

    rule
        buildTestMethodCall(
            TraitName:TypePath,
            MethodName:Identifier,
            Args:NormalizedCallParams,
            0
        ) => normalizedMethodCall(TraitName, MethodName, Args)

    rule
        <k> (V:PtrValue ~> return_value) => .K ... </k>
        <test-stack> .List => ListItem(V) ... </test-stack>

    rule
        <k> check_eq ptrValue(_, V:Value) => .K ... </k>
        <test-stack> ListItem(ptrValue(_, V)) => .List ... </test-stack>

    rule
        <k> push ptrValue(_, V:Value) => .K ... </k>
        <test-stack> .List => ListItem(ptr(NVI)) ... </test-stack>
        <values> VALUES:Map => VALUES[NVI <- V] </values>
        <next-value-id> NVI:Int => NVI +Int 1 </next-value-id>

endmodule

```
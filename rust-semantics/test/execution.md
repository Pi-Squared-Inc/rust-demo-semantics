```k

module RUST-EXECUTION-TEST-PARSING-SYNTAX
    imports RUST-SHARED-SYNTAX

    syntax ExecutionTest ::= NeList{ExecutionItem, ";"}
    // syntax ExecutionTest ::= ExecutionItem ";" ExecutionItem
    syntax ExecutionItem  ::= "new" TypePath
                            | "call" TypePath "." Identifier
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

    rule E:ExecutionItem ; Es:ExecutionTest => E ~> Es
    rule .ExecutionTest => .K

    rule
        <k> new P:TypePath => .K ... </k>
        <test-stack> .List => ListItem(NVI) ... </test-stack>
        <trait-path> P </trait-path>
        <values> VALUES:Map => VALUES[NVI <- struct(P, .Map)] </values>
        <next-value-id> NVI:Int => NVI +Int 1 </next-value-id>

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
endmodule

```
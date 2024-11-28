```k

module ULM-SEMANTICS-HOOKS-DEBUG-CONFIGURATION
    imports LIST

    configuration
        <ulm-debug>
            .List
        </ulm-debug>
endmodule

module ULM-SEMANTICS-HOOKS-DEBUG-SYNTAX
    imports RUST-SHARED-SYNTAX

    syntax Instruction ::= debugExpression(Expression)
endmodule

// Either ULM-SEMANTICS-HOOKS-NO-DEBUG or ULM-SEMANTICS-HOOKS-DEBUG should be
// included directly in the target module.
module ULM-SEMANTICS-HOOKS-NO-DEBUG
    imports private ULM-SEMANTICS-HOOKS-DEBUG-FUNCTIONS
    imports private ULM-SEMANTICS-HOOKS-DEBUG-SYNTAX

    rule debugExpression(_:Expression) => .K
endmodule

module ULM-SEMANTICS-HOOKS-DEBUG
    imports private COMMON-K-CELL
    imports private RUST-REPRESENTATION
    imports private ULM-SEMANTICS-HOOKS-DEBUG-CONFIGURATION
    imports private ULM-SEMANTICS-HOOKS-DEBUG-FUNCTIONS
    imports private ULM-SEMANTICS-HOOKS-DEBUG-SYNTAX

    rule debugExpression(E:Expression) => debugExpressionImpl(E)

    syntax Instruction ::= debugExpressionImpl(Expression)  [strict(1)]

    rule
        <k> debugExpressionImpl(V:PtrValue) => .K ... </k>
        <ulm-debug>
            ...
            .List => ListItem(V)
        </ulm-debug>
endmodule

module ULM-SEMANTICS-HOOKS-DEBUG-FUNCTIONS
    imports private RUST-REPRESENTATION
    imports private ULM-SEMANTICS-HOOKS-DEBUG-SYNTAX

    syntax Identifier ::= "debug"  [token]

    rule
        normalizedFunctionCall
            ( :: debug :: _:Identifier :: .PathExprSegments
            , ValueId:Ptr, .PtrList
            )
        => debugExpression(ValueId)

endmodule

```

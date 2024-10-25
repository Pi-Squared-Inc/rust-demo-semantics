```k

module ULM-SEMANTICS-HOOKS-HELPERS-SYNTAX
    syntax UlmInstruction ::= "ulmCancel"
endmodule

module ULM-SEMANTICS-HOOKS-HELPERS
    imports private COMMON-K-CELL
    imports private RUST-REPRESENTATION
    imports private ULM-SEMANTICS-HOOKS-HELPERS-SYNTAX

    syntax Identifier ::= "cancel_request"  [token]
                        | "helpers"  [token]

    rule
        normalizedFunctionCall
            ( :: helpers :: cancel_request :: .PathExprSegments
            , .PtrList
            )
        => ulmCancel

    rule (ulmCancel ~> _:KItem) => ulmCancel
        [owise]
endmodule

```

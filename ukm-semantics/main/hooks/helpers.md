```k

module UKM-HOOKS-HELPERS-SYNTAX
    syntax UkmInstruction ::= "ukmCancel"
endmodule

module UKM-HOOKS-HELPERS
    imports private COMMON-K-CELL
    imports private RUST-REPRESENTATION
    imports private UKM-HOOKS-HELPERS-SYNTAX

    syntax Identifier ::= "cancel_request"  [token]
                        | "helpers"  [token]

    rule
        normalizedFunctionCall
            ( :: helpers :: cancel_request :: .PathExprSegments
            , .PtrList
            )
        => ukmCancel

    rule (ukmCancel ~> _:KItem) => ukmCancel
        [owise]
endmodule

```

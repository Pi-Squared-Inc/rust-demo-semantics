```k

module RUST-EXPRESSION-VARIABLES
    imports COMMON-K-CELL
    imports RUST-EXECUTION-CONFIGURATION
    imports RUST-VALUE-SYNTAX
    imports RUST-SHARED-SYNTAX

    rule
        <k>
            Variable:Identifier :: .PathExprSegments => V
            ...
        </k>
        <locals> Variable |-> VarId:Int ... </locals>
        <values> VarId |-> V:Value ... </values>
endmodule

```
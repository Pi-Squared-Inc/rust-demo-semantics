```k

module RUST-EXPRESSION-VARIABLES
    imports private COMMON-K-CELL
    imports private RUST-EXECUTION-CONFIGURATION
    imports private RUST-REPRESENTATION
    imports private RUST-SHARED-SYNTAX
    imports private RUST-VALUE-SYNTAX

    rule
        <k>
            Variable:Identifier :: .PathExprSegments => ptrValue(ptr(VarId), V)
            ...
        </k>
        <locals> Variable |-> VarId:Int ... </locals>
        <values> VarId |-> V:Value ... </values>

    rule
        <k>
            self :: .PathExprSegments => ptrValue(ptr(VarId), V)
            ...
        </k>
        <locals> self:PathIdentSegment |-> VarId:Int ... </locals>
        <values> VarId |-> V:Value ... </values>

    rule [[isLocalVariable(Name:ValueName) => true]]
        <locals> Locals </locals>
        requires Name in_keys(Locals)
    rule isLocalVariable(_) => false  [owise]

endmodule

```
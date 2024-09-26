```k

module RUST-EXPRESSION-VARIABLES
    imports private COMMON-K-CELL
    imports private RUST-EXECUTION-CONFIGURATION
    imports private RUST-REPRESENTATION
    imports private RUST-SHARED-SYNTAX
    imports private RUST-VALUE-SYNTAX

    rule Thing:PathIdentSegment :: .PathExprSegments => Thing:PathIdentSegment:KItem

    rule
        <k>
            Variable:Identifier => ptrValue(ptr(VarId), V)
            ...
        </k>
        <locals> Variable |-> VarId:Int ... </locals>
        <values> VarId |-> V:Value ... </values>

    rule
        <k>
            self:PathIdentSegment => ptrValue(ptr(VarId), V)
            ...
        </k>
        <locals> self:PathIdentSegment |-> VarId:Int ... </locals>
        <values> VarId |-> V:Value ... </values>

    rule
        <k> ptr(I:Int) => ptrValue(ptr(I), V) ... </k>
        <values> I |-> V:Value ... </values>

    rule [[isLocalVariable(Name:ValueName) => true]]
        <locals> Locals </locals>
        requires Name in_keys(Locals)
    rule isLocalVariable(_) => false  [owise]

endmodule

```
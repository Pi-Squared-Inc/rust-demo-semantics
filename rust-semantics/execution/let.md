```k

module RUST-LET
    imports COMMON-K-CELL
    imports RUST-CASTS
    imports RUST-EXECUTION-CONFIGURATION
    imports RUST-VALUE-SYNTAX
    imports RUST-SHARED-SYNTAX

    // Not all cases are implemented
    rule
        <k>
            let Variable:Identifier : T:Type = ptrValue(_, V:Value) ; => .K
            ...
        </k>
        <next-value-id> NextId:Int => NextId +Int 1 </next-value-id>
        <locals> Locals:Map => Locals[Variable <- NextId] </locals>
        <values> Values:Map => Values[NextId <- implicitCast(V, T)] </values>
    rule
        <k>
            let Variable:Identifier = ptrValue(_, V:Value) ; => .K
            ...
        </k>
        <next-value-id> NextId:Int => NextId +Int 1 </next-value-id>
        <locals> Locals:Map => Locals[Variable <- NextId] </locals>
        <values> Values:Map => Values[NextId <- V] </values>
    requires notBool mayBeDefaultTypedInt(V)
endmodule

```
```k

module RUST-LET
    imports private COMMON-K-CELL
    imports private RUST-CASTS
    imports private RUST-EXECUTION-CONFIGURATION
    imports private RUST-REPRESENTATION
    imports private RUST-SHARED-SYNTAX
    imports private RUST-VALUE-SYNTAX

    // Not all cases are implemented

    // Handling immutable variables
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

    // Handling mutable variables
    rule
        <k>
            let mut Variable:Identifier : T:Type = ptrValue(_, V:Value) ; => .K
            ...
        </k>
        <next-value-id> NextId:Int => NextId +Int 1 </next-value-id>
        <locals> Locals:Map => Locals[Variable <- NextId] </locals>
        <values> Values:Map => Values[NextId <- implicitCast(V, T)] </values>
    rule
        <k>
            let mut Variable:Identifier = ptrValue(_, V:Value) ; => .K
            ...
        </k>
        <next-value-id> NextId:Int => NextId +Int 1 </next-value-id>
        <locals> Locals:Map => Locals[Variable <- NextId] </locals>
        <values> Values:Map => Values[NextId <- V] </values>
    requires notBool mayBeDefaultTypedInt(V)

    // Handling tuple assignments 
    rule
        <k>
            let (Variable:PatternNoTopAlt | .PatternNoTopAlts , RemainingToAssign:Patterns):TuplePattern 
                = ptrValue(_,tuple(Val:Value, ValList:ValueList)) ; 
            =>
                let Variable = ptrValue(null, Val); 
                ~> let (RemainingToAssign:Patterns:TuplePatternItems):TuplePattern 
                    = ptrValue(null, tuple(ValList));
            ...
        </k>

    rule
        <k>
            let (.Patterns):TuplePattern = 
            ptrValue(_,tuple(.ValueList))
            ; => .K
            ...
        </k>
    
    // Handles the case where the tuple pattern on the let expression has an extra comma, removing it
    rule
        <k>
            let (Variable:PatternNoTopAlt | .PatternNoTopAlts , RemainingToAssign:Patterns,):TuplePattern 
                = ptrValue(_,tuple(Val:Value, ValList:ValueList)); 
            => 
                let (Variable:PatternNoTopAlt | .PatternNoTopAlts , RemainingToAssign:Patterns):TuplePattern 
                = ptrValue(null,tuple(Val:Value, ValList:ValueList));
            ...
        </k>


endmodule

```
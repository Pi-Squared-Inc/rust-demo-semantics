```k

module RUST-EXPRESSION-ASSIGNMENTS
    imports private COMMON-K-CELL
    imports private RUST-EXECUTION-CONFIGURATION
    imports private RUST-SHARED-SYNTAX
    imports private RUST-VALUE-SYNTAX

    rule
        <k>
            ptrValue(ptr(P:Int), _) = ptrValue(_, V:Value)
            => ptrValue(null, tuple(.ValueList))
            ...
        </k>
        <values>
            Values:Map => Values[P <- V]
        </values>
        <mutables> Mutables:Set </mutables>
        requires P in_keys(Values) andBool P in Mutables

    rule
        <k>
            ptrValue(ptr(P:Int), _) = ptrValue(_, _)
            => error("cannot assign twice to immutable variable", P)
            ...
        </k>
        <values> Values:Map </values>
        <mutables> Mutables:Set </mutables>
        requires P in_keys(Values) andBool notBool P in Mutables

endmodule

```
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
        requires P in_keys(Values)

endmodule

```
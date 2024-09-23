```k

module RUST-EXPRESSION-TUPLE
    imports RUST-REPRESENTATION
    imports RUST-VALUE-SYNTAX

    rule ():Expression => ptrValue(null, tuple(.ValueList))

endmodule
```

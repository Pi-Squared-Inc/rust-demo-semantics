```k

module RUST-BOOL-OPERATIONS
    imports private RUST-BOOL-LOGICAL-OPERATIONS
endmodule

module RUST-BOOL-LOGICAL-OPERATIONS
    imports RUST-SHARED-SYNTAX
    imports private RUST-REPRESENTATION

    rule ptrValue(_, A:Bool) && ptrValue(_, B:Bool) => ptrValue(null, A andBool B)
    rule ptrValue(_, A:Bool) || ptrValue(_, B:Bool) => ptrValue(null, A orBool B)
    rule ! ptrValue(_, B:Bool) => ptrValue(null, notBool B)

endmodule

```

```k

module MX-RUST-EXPRESSION-RAW-VALUE
    imports private MX-RUST-REPRESENTATION

    rule rawValue(V:Value) => mxRustNewValue(V)

endmodule

```

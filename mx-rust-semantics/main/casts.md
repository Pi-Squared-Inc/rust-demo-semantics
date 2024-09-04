```k

module MX-RUST-CASTS
    imports private MX-COMMON-SYNTAX
    imports private MX-RUST-REPRESENTATION
    imports private RUST-REPRESENTATION

    rule mxIntValue(I:Int) ~> mxValueToRust(T:Type)
        => mxRustNewValue(integerToValue(I, T))
endmodule

```
```k

module ULM-DECODING-SYNTAX
    imports BYTES-SYNTAX
    imports RUST-CRATE-LIST-SYNTAX

    syntax WrappedCrateList ::= ulmDecodeRustCrates(Bytes)
                                [function, hook(ULM.decode)]

endmodule

```
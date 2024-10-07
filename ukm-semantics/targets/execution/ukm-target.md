```k

requires "../../main/decoding.md"
requires "../../main/execution.md"
requires "configuration.md"
requires "rust-semantics/rust-common.md"
requires "rust-semantics/rust-common-syntax.md"

module UKM-TARGET-SYNTAX
endmodule

module UKM-TARGET
    imports private RUST-COMMON
    imports private UKM-DECODING
    imports private UKM-EXECUTION
    imports private UKM-TARGET-CONFIGURATION
endmodule

```

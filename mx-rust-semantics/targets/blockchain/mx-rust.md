```k

requires "configuration.md"
requires "mx-semantics/main/mx-common.md"
requires "mx-semantics/main/syntax.md"
requires "rust-semantics/rust-common.md"
requires "rust-semantics/rust-common-syntax.md"

module MX-RUST-SYNTAX
    imports RUST-COMMON-SYNTAX
endmodule

module MX-RUST
    imports private MX-COMMON
    imports private MX-RUST-CONFIGURATION
    imports private RUST-COMMON
endmodule

```

```k

requires "mx-semantics/main/mx-common.md"
requires "mx-semantics/main/syntax.md"
requires "rust-semantics/rust-common.md"
requires "rust-semantics/rust-common-syntax.md"
requires "../../main/mx-rust-common.md"

module MX-RUST-COMMON-TARGET-SYNTAX
    imports RUST-COMMON-SYNTAX
endmodule

module MX-RUST-COMMON-TARGET
    imports private MX-COMMON
    imports private MX-RUST-COMMON
    imports private MX-RUST-CONFIGURATION
    imports private RUST-COMMON
endmodule

```

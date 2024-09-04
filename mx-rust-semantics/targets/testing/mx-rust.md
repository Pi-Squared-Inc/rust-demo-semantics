```k

requires "configuration.md"
requires "mx-semantics/main/mx-common.md"
requires "mx-semantics/main/syntax.md"
requires "mx-semantics/test/configuration.md"
requires "mx-semantics/test/execution.md"
requires "rust-semantics/rust-common.md"
requires "rust-semantics/rust-common-syntax.md"
requires "rust-semantics/test/configuration.md"
requires "rust-semantics/test/execution.md"
requires "../../main/mx-rust-common.md"
requires "../../test/execution.md"

module MX-RUST-SYNTAX
    imports RUST-COMMON-SYNTAX
    imports MX-RUST-TESTING-PARSING-SYNTAX
endmodule

module MX-RUST
    imports private MX-COMMON
    imports private MX-RUST-TEST
    imports private MX-RUST-CONFIGURATION
    imports private MX-RUST-COMMON
    imports private MX-TEST-EXECUTION
    imports private RUST-COMMON
    imports private RUST-EXECUTION-TEST
endmodule

```

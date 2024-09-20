```k

requires "configuration-testing.md"
requires "mx-rust.md"
requires "mx-semantics/main/mx-common.md"
requires "mx-semantics/main/syntax.md"
requires "mx-semantics/setup/setup.md"
requires "mx-semantics/test/configuration.md"
requires "mx-semantics/test/execution.md"
requires "rust-semantics/rust-common.md"
requires "rust-semantics/rust-common-syntax.md"
requires "rust-semantics/test/configuration.md"
requires "rust-semantics/test/execution.md"
requires "../../main/mx-rust-common.md"
requires "../../main/representation.md"
requires "../../setup/mx.md"
requires "../../test/execution.md"

module MX-RUST-COMMON-TEST-SYNTAX
    imports RUST-COMMON-SYNTAX
    imports MX-RUST-TESTING-PARSING-SYNTAX
endmodule

module MX-RUST-COMMON-TEST
    imports private MX-RUST-COMMON-TARGET
    imports private MX-RUST-TEST
    imports private MX-RUST-SETUP-MX
    imports private MX-SETUP
    imports private MX-TEST-EXECUTION
    imports private RUST-EXECUTION-TEST
endmodule

```

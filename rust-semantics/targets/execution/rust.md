```k

requires "configuration.md"
requires "../../rust-common.md"
requires "../../rust-common-syntax.md"
requires "../../test.md"

module RUST-SYNTAX
    imports RUST-COMMON-SYNTAX
    imports RUST-EXECUTION-TEST-PARSING-SYNTAX
endmodule

module RUST
    imports RUST-COMMON
    imports RUST-EXECUTION-TEST
    imports RUST-RUNNING-CONFIGURATION
endmodule

```
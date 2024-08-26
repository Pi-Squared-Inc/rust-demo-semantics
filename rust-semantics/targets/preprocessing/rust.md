```k

requires "configuration.md"
requires "../../preprocessing.md"
requires "../../representation.md"
requires "../../expression.md"
requires "../../rust-common-syntax.md"

module RUST-SYNTAX
    imports RUST-COMMON-SYNTAX
endmodule

module RUST
    imports private RUST-EXPRESSION
    imports private RUST-PREPROCESSING
    imports private RUST-RUNNING-CONFIGURATION
endmodule

```

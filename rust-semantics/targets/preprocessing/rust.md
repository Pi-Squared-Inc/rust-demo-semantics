```k

requires "configuration.md"
requires "../../preprocessing.md"
requires "../../representation.md"
requires "../../expression/casts.md"
requires "../../expression/constants.md"
requires "../../expression/literals.md"
requires "../../rust-common-syntax.md"

module RUST-SYNTAX
    imports RUST-COMMON-SYNTAX
endmodule

module RUST
    imports private RUST-EXPRESSION-LITERALS
    imports private RUST-EXPRESSION-CONSTANTS
    imports private RUST-PREPROCESSING
    imports private RUST-RUNNING-CONFIGURATION
endmodule

```

```k

requires "configuration.md"
requires "../../full-preprocessing.md"
requires "../../rust-common-syntax.md"

module RUST-SYNTAX
    imports RUST-COMMON-SYNTAX
endmodule

module RUST
    imports private RUST-FULL-PREPROCESSING
    imports private RUST-RUNNING-CONFIGURATION
endmodule

```

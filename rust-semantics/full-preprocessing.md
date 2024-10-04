```k

requires "error.md"
requires "expression/bool-operations.md"
requires "expression/casts.md"
requires "expression/constants.md"
requires "expression/integer-operations.md"
requires "expression/literals.md"
requires "preprocessing.md"
requires "representation.md"
requires "rust-common-syntax.md"

module RUST-FULL-PREPROCESSING
    imports private RUST-BOOL-OPERATIONS
    imports private RUST-ERROR
    imports private RUST-EXPRESSION-CONSTANTS
    imports private RUST-EXPRESSION-LITERALS
    imports private RUST-INTEGER-OPERATIONS
    imports private RUST-PREPROCESSING
    imports private RUST-REPRESENTATION

    // Making a warning go away
    rule isLocalVariable(_) => false
endmodule

```

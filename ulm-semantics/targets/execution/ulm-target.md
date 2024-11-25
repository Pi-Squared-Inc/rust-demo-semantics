```k

requires "../../main/decoding.md"
requires "../../main/encoding.md"
requires "../../main/execution.md"
requires "../../main/preprocessing.md"
requires "configuration.md"
requires "rust-semantics/full-preprocessing.md"
requires "rust-semantics/rust-common.md"
requires "rust-semantics/rust-common-syntax.md"


module ULM-TARGET-SYNTAX
    imports RUST-CRATES-SYNTAX
endmodule

module ULM-TARGET
    imports private RUST-COMMON
    imports private RUST-FULL-PREPROCESSING
    imports private ULM-DECODING
    imports private ULM-ENCODING
    imports private ULM-EXECUTION
    imports private ULM-PREPROCESSING
    imports private ULM-SEMANTICS-HOOKS-NO-DEBUG
    imports private ULM-SEMANTICS-HOOKS-TO-ULM-FUNCTIONS
    imports private ULM-TARGET-CONFIGURATION
endmodule

```

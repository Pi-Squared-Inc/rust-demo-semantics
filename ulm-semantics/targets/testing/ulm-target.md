```k

requires "../../main/encoding.md"
requires "../../main/execution.md"
requires "../../main/preprocessing.md"
requires "../../test/execution.md"
requires "configuration.md"
requires "rust-semantics/rust-common.md"
requires "rust-semantics/rust-common-syntax.md"
requires "rust-semantics/full-preprocessing.md"
requires "rust-semantics/test/execution.md"

module ULM-TARGET-SYNTAX
    imports RUST-COMMON-SYNTAX
    imports ULM-TEST-SYNTAX
endmodule

module ULM-TARGET
    imports private RUST-COMMON
    imports private RUST-FULL-PREPROCESSING
    imports private RUST-EXECUTION-TEST
    imports private ULM-CALLDATA-ENCODER
    imports private ULM-EXECUTION
    imports private ULM-ENCODING
    imports private ULM-PREPROCESSING
    imports private ULM-SEMANTICS-HOOKS-DEBUG
    imports private ULM-TARGET-CONFIGURATION
    imports private ULM-TEST-EXECUTION
endmodule

```

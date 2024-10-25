```k

requires "../../main/decoding.md"
requires "../../main/encoding.md"
requires "../../main/execution.md"
requires "../../main/preprocessing.md"
requires "../../test/execution.md"
requires "configuration.md"
requires "rust-semantics/rust-common.md"
requires "rust-semantics/rust-common-syntax.md"
requires "rust-semantics/full-preprocessing.md"
requires "rust-semantics/test/execution.md"

module UKM-TARGET-SYNTAX
    imports RUST-COMMON-SYNTAX
    imports UKM-TEST-SYNTAX
endmodule

module UKM-TARGET
    imports private RUST-COMMON
    imports private RUST-FULL-PREPROCESSING
    imports private RUST-EXECUTION-TEST
    imports private UKM-CALLDATA-ENCODER
    imports private UKM-EXECUTION
    imports private UKM-ENCODING
    imports private UKM-PREPROCESSING
    imports private UKM-TARGET-CONFIGURATION
    imports private UKM-TEST-EXECUTION
endmodule

```

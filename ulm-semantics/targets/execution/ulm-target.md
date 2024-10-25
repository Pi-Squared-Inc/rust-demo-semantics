```k

requires "../../main/decoding.md"
requires "../../main/execution.md"
requires "configuration.md"
requires "rust-semantics/rust-common.md"
requires "rust-semantics/rust-common-syntax.md"

module ULM-TARGET-SYNTAX
endmodule

module ULM-TARGET
    imports private RUST-COMMON
    imports private ULM-DECODING
    imports private ULM-EXECUTION
    imports private ULM-SEMANTICS-HOOKS-TO-ULM-FUNCTIONS
    imports private ULM-TARGET-CONFIGURATION
endmodule

```

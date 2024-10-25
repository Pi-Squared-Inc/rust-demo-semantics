```k

requires "../../main/configuration.md"
requires "../../main/preprocessed-configuration.md"
requires "../../test/configuration.md"
requires "rust-semantics/config.md"
requires "rust-semantics/test/configuration.md"

module COMMON-K-CELL
    imports private RUST-EXECUTION-TEST-PARSING-SYNTAX
    imports private RUST-PREPROCESSING-SYNTAX
    imports private ULM-PREPROCESSING-SYNTAX

    configuration
        <k>
            cratesParser($PGM:WrappedCrateList)
            ~> ulmPreprocessCrates
            ~> $TEST:ExecutionTest
        </k>
endmodule

module ULM-TARGET-CONFIGURATION
    imports COMMON-K-CELL
    imports RUST-EXECUTION-CONFIGURATION
    imports RUST-EXECUTION-TEST-CONFIGURATION
    imports ULM-CONFIGURATION
    imports ULM-FULL-PREPROCESSED-CONFIGURATION
    imports ULM-PREPROCESSING-EPHEMERAL-CONFIGURATION
    imports ULM-TEST-CONFIGURATION

    configuration
        <ulm-full-preprocessed/>
        <ulm-preprocessing-ephemeral/>
        <ulm/>
        <ulm-test/>
        <rust-test/>
        <execution/>
        <k/>
endmodule

```

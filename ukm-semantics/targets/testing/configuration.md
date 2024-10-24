```k

requires "../../main/configuration.md"
requires "../../main/preprocessed-configuration.md"
requires "../../test/configuration.md"
requires "rust-semantics/config.md"
requires "rust-semantics/test/configuration.md"

module COMMON-K-CELL
    imports private RUST-EXECUTION-TEST-PARSING-SYNTAX
    imports private RUST-PREPROCESSING-SYNTAX
    imports private UKM-PREPROCESSING-SYNTAX

    configuration
        <k>
            cratesParser($PGM:WrappedCrateList)
            ~> ukmPreprocessCrates
            ~> $TEST:ExecutionTest
        </k>
endmodule

module UKM-TARGET-CONFIGURATION
    imports COMMON-K-CELL
    imports RUST-EXECUTION-CONFIGURATION
    imports RUST-EXECUTION-TEST-CONFIGURATION
    imports UKM-CONFIGURATION
    imports UKM-FULL-PREPROCESSED-CONFIGURATION
    imports UKM-PREPROCESSING-EPHEMERAL-CONFIGURATION
    imports UKM-TEST-CONFIGURATION

    configuration
        <ukm-full-preprocessed/>
        <ukm-preprocessing-ephemeral/>
        <ukm/>
        <ukm-test/>
        <rust-test/>
        <execution/>
        <k/>
endmodule

```

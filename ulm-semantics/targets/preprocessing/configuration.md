```k

requires "../../main/configuration.md"
requires "../../main/preprocessed-configuration.md"
requires "rust-semantics/config.md"
requires "rust-semantics/full-preprocessing.md"
requires "rust-semantics/rust-common-syntax.md"

module COMMON-K-CELL
    imports private RUST-PREPROCESSING-SYNTAX
    imports private ULM-ENCODING-SYNTAX
    imports private ULM-PREPROCESSING-SYNTAX

    configuration
        <k>
            cratesParser($PGM:WrappedCrateList)
            ~> ulmPreprocessCrates
        </k>
endmodule

module ULM-TARGET-CONFIGURATION
    imports COMMON-K-CELL
    imports ULM-FULL-PREPROCESSED-CONFIGURATION
    imports ULM-PREPROCESSING-EPHEMERAL-CONFIGURATION

    configuration
        <ulm-full-preprocessed/>
        <ulm-preprocessing-ephemeral/>
        <k/>
endmodule

```

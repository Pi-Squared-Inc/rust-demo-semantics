```k

requires "../../main/configuration.md"
requires "../../main/preprocessed-configuration.md"
requires "rust-semantics/config.md"
requires "rust-semantics/full-preprocessing.md"
requires "rust-semantics/rust-common-syntax.md"

module COMMON-K-CELL
    imports private RUST-PREPROCESSING-SYNTAX
    imports private UKM-ENCODING-SYNTAX
    imports private UKM-PREPROCESSING-SYNTAX

    configuration
        <k>
            cratesParser($PGM:WrappedCrateList)
            ~> ukmPreprocessCrates
            ~> ukmEncodePreprocessedCell
        </k>
endmodule

module UKM-TARGET-CONFIGURATION
    imports COMMON-K-CELL
    imports UKM-FULL-PREPROCESSED-CONFIGURATION
    imports UKM-PREPROCESSING-EPHEMERAL-CONFIGURATION

    configuration
        <ukm-target>
            <ukm-full-preprocessed/>
            <ukm-preprocessing-ephemeral/>
            <k/>
        </ukm-target>
endmodule

```

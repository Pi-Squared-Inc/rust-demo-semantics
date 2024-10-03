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
            crateParser($CRATE1:Crate)
            ~> crateParser($CRATE2:Crate)
            ~> crateParser($CRATE3:Crate)
            ~> crateParser($CRATE4:Crate)
            ~> ukmPreprocessCrates
            ~> ukmEncodePreprocessedCell
        </k>
endmodule

module UKM-TARGET-CONFIGURATION
    imports COMMON-K-CELL
    imports UKM-FULL-PREPROCESSED-CONFIGURATION

    configuration
        <ukm-target>
            <ukm-full-preprocessed/>
            <k/>
        </ukm-target>
endmodule

```

```k

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

```

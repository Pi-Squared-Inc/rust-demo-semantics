```k

module COMMON-K-CELL
    imports MX-RUST-REPRESENTATION
    imports RUST-PREPROCESSING-SYNTAX
    imports RUST-SHARED-SYNTAX

    syntax MxRustTest

    configuration
        <k> crateParser($PGM:Crate, $CRATE_PATH:TypePath)
            ~> mxRustPreprocessTraits
            ~> ($TEST:MxRustTest):KItem
        </k>
endmodule

```

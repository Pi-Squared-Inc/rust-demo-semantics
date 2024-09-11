```k

requires "../../main/configuration.md"
requires "../../test/configuration.md"

module COMMON-K-CELL
    imports MX-RUST-REPRESENTATION
    imports RUST-PREPROCESSING-SYNTAX
    imports RUST-SHARED-SYNTAX

    syntax MxRustTest

    configuration
        <k> crateParser($PGM:Crate) ~> mxRustPreprocessTraits ~> ($TEST:MxRustTest):KItem </k>
endmodule

module MX-RUST-CONFIGURATION
    imports COMMON-K-CELL
    imports MX-RUST-COMMON-CONFIGURATION
    imports MX-RUST-EXECUTION-TEST-CONFIGURATION

    configuration
        <mx-rust-cfg>
            <mx-rust-test/>
            <mx-rust/>
            <k/>
        </mx-rust-cfg>
endmodule

```

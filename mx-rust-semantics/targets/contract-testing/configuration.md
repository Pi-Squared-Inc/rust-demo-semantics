```k

requires "../../main/configuration.md"
requires "../../test/configuration.md"

module COMMON-K-CELL
    imports MX-RUST-REPRESENTATION
    imports RUST-SHARED-SYNTAX
    imports STRING

    syntax MxRustTest

    configuration
        <k>
            mxRustCreateAccount("Owner")
            ~> mxRustCreateContract
                (... owner: "Owner"
                , contractAccount: "TestContract"
                , code: $PGM:Crate
                , args: $ARGS:MxValueList
                )
            ~> ($TEST:MxRustTest):KItem
        </k>
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

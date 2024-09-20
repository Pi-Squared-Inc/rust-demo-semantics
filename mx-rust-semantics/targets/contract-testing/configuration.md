```k

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

```

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
                , contractAccount: "TestContract1"
                , code: $PGM1:Crate
                , args: $ARGS1:MxValueList
                )
            ~> mxRustCreateContract
                (... owner: "Owner"
                , contractAccount: "TestContract2"
                , code: $PGM2:Crate
                , args: $ARGS2:MxValueList
                )
            ~> ($TEST:MxRustTest):KItem
        </k>
endmodule

```

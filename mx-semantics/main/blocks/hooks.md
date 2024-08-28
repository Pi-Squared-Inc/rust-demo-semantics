```k

module MX-BLOCKS-HOOKS
    imports private COMMON-K-CELL
    imports private MX-BLOCKS-CONFIGURATION
    imports private MX-COMMON-SYNTAX

    rule
        <k> MX#getBlockTimestamp ( .MxHookArgs ) => mxIntValue(T) ... </k>
        <mx-current-block-timestamp> T </mx-current-block-timestamp>

endmodule

```

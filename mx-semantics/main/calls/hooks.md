```k

module MX-CALLS-HOOKS
    imports private COMMON-K-CELL
    imports private MX-CALL-CONFIGURATION
    imports private MX-COMMON-SYNTAX

    rule
        <k> MX#getCaller ( .MxHookArgs ) => mxStringValue(Caller) ... </k>
        <mx-caller> Caller:String </mx-caller>

endmodule

```
```k

module MX-ERRORS-HOOKS
    imports private MX-COMMON-SYNTAX

    rule MX#signalError(mxStringValue(Message:String)) => #exception(UserError, Message)

endmodule

```

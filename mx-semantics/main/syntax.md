```k

module MX-COMMON-SYNTAX
    imports INT-SYNTAX

    syntax MxValue ::= mxIntValue(Int)
    syntax MxHookName ::= r"MX#[a-zA-Z][a-zA-Z0-9]*"  [token]
    syntax MxHookArgs ::= List{MxValue, ","}
    syntax HookCall ::= MxHookName "(" MxHookArgs ")"
endmodule

```

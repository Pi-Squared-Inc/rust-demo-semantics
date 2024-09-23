```k

module MX-RUST-CALLS-MACROS
    imports private RUST-SHARED-SYNTAX
    imports private RUST-VALUE-SYNTAX
    imports private MX-COMMON-SYNTAX

    syntax MxRustInstruction ::= requireMacro(condition:Expression, message:Expression)
                                    [seqstrict]

    rule ( #token("require", "Identifier") :: .SimplePathList !
            ( Condition:Expression, Message:Expression, .CallParamsList ) ;
        ):MacroInvocationSemi:KItem
        => requireMacro(... condition:Condition, message:Message)

    rule requireMacro(... condition: ptrValue(_, true), message: _:PtrValue) => .K
    rule requireMacro(... condition: ptrValue(_, false), message: ptrValue(_, Message:String))
        => MX#signalError(mxStringValue(Message))

endmodule

```

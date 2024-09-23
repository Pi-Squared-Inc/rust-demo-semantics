```k

module MX-ERRORS-TOOLS
    imports private COMMON-K-CELL
    imports private K-EQUAL-SYNTAX
    imports private MX-CALL-RESULT-CONFIGURATION
    imports private MX-COMMON-SYNTAX

    syntax MxInstructions ::= setErrorVMOutput(ExceptionCode, String)

    rule #exception(_, _) ~> (Next:KItem => .K)
        requires Next =/=K endCall
    rule #exception(Code, Message) ~> endCall
        => setErrorVMOutput(Code, Message) ~> popCallState ~> popWorldState

    rule [setErrorVMOutput]:
        <k> setErrorVMOutput(Code, Message) => .K ... </k>
        <mx-call-result>
            _ => mxCallResult
                    (... returnCode: Code
                    , returnMessage: Message
                    , out: mxListValue(.MxValueList)
                    )
        </mx-call-result>
endmodule

```

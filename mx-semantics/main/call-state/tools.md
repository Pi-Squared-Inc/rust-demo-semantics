```k

module MX-CALL-STATE-TOOLS
    imports private COMMON-K-CELL
    imports private MX-CALL-STATE-CONFIGURATION
    imports private MX-CALL-STATE-STACK-CONFIGURATION
    imports private MX-COMMON-SYNTAX

    rule
        <k> pushCallState => host.pushCallState ... </k>
        State:MxCallStateCell
        <mx-call-state-stack>
            (.List => ListItem(State))
            ...
        </mx-call-state-stack>

    rule
        <k> popCallState => host.popCallState ... </k>
        (_:MxCallStateCell => State)
        <mx-call-state-stack>
            (ListItem(State:MxCallStateCell) => .List)
            ...
        </mx-call-state-stack>

    rule
        <k> resetCallState => host.resetCallState ... </k>
        ( _:MxCallStateCell
            =>  <mx-call-state>
                    <mx-biguint>
                        <bigIntHeap> .Map </bigIntHeap>
                        ...
                    </mx-biguint>
                    ...
                </mx-call-state>
        )

endmodule

```

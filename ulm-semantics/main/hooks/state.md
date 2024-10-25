```k

module ULM-SEMANTICS-HOOKS-STATE-CONFIGURATION
    imports BYTES-SYNTAX
    imports INT-SYNTAX

    configuration
        <ulm-state>
            <ulm-status> 0 </ulm-status>
            <ulm-output> b"" </ulm-output>
            <ulm-gas> 0 </ulm-gas>
        </ulm-state>
endmodule

module ULM-SEMANTICS-HOOKS-STATE
    imports private COMMON-K-CELL
    imports private RUST-REPRESENTATION
    imports private RUST-SHARED-SYNTAX
    imports private ULM-SEMANTICS-HOOKS-STATE-CONFIGURATION
    imports private ULM-REPRESENTATION

    syntax ULMInstruction ::= ulmSetStatus(Expression)  [strict(1)]
                            | ulmSetGasLeft(Expression)  [strict(1)]
                            | ulmSetOutput(Expression)  [strict(1)]
                            | ulmSetOutput(UlmExpression)  [strict(1)]

    syntax Identifier ::= "state_hooks"  [token]
                        | "setStatus"  [token]
                        | "setGasLeft"  [token]
                        | "setOutput"  [token]

    rule normalizedFunctionCall
            ( :: state_hooks :: setStatus :: .PathExprSegments
            , StatusId:Ptr , .PtrList
            )
        => ulmSetStatus(StatusId)

    rule normalizedFunctionCall
            ( :: state_hooks :: setGasLeft :: .PathExprSegments
            , GasId:Ptr , .PtrList
            )
        => ulmSetGasLeft(GasId)

    rule normalizedFunctionCall
            ( :: state_hooks :: setOutput :: .PathExprSegments
            , OutputId:Ptr , .PtrList
            )
        => ulmSetOutput(OutputId)

    rule
        <k>
            ulmSetStatus(ptrValue(_, u64(Value))) => ptrValue(null, tuple(.ValueList))
            ...
        </k>
        <ulm-status> _ => MInt2Unsigned(Value) </ulm-status>

    rule
        <k>
            ulmSetGasLeft(ptrValue(_, u64(Value))) => ptrValue(null, tuple(.ValueList))
            ...
        </k>
        <ulm-gas> _ => MInt2Unsigned(Value) </ulm-gas>

    rule ulmSetOutput(ptrValue(_, u64(BytesId))) => ulmSetOutput(ulmBytesId(BytesId))
    rule
        <k>
            ulmSetOutput(ulmBytesValue(Value:Bytes)) => ptrValue(null, tuple(.ValueList))
            ...
        </k>
        <ulm-output> _ => Value </ulm-output>

endmodule

```

```k

module UKM-HOOKS-STATE-CONFIGURATION
    imports BYTES-SYNTAX
    imports INT-SYNTAX

    configuration
        <ukm-state>
            <ukm-status> 0 </ukm-status>
            <ukm-output> b"" </ukm-output>
            <ukm-gas> 0 </ukm-gas>
        </ukm-state>
endmodule

module UKM-HOOKS-STATE
    imports private COMMON-K-CELL
    imports private RUST-REPRESENTATION
    imports private RUST-SHARED-SYNTAX
    imports private UKM-HOOKS-STATE-CONFIGURATION
    imports private UKM-REPRESENTATION

    syntax UKMInstruction ::= ukmSetStatus(Expression)  [strict(1)]
                            | ukmSetGasLeft(Expression)  [strict(1)]
                            | ukmSetOutput(Expression)  [strict(1)]
                            | ukmSetOutput(UkmExpression)  [strict(1)]

    syntax Identifier ::= "state_hooks"  [token]
                        | "setStatus"  [token]
                        | "setGasLeft"  [token]
                        | "setOutput"  [token]

    rule normalizedFunctionCall
            ( :: state_hooks :: setStatus :: .PathExprSegments
            , StatusId:Ptr , .PtrList
            )
        => ukmSetStatus(StatusId)

    rule normalizedFunctionCall
            ( :: state_hooks :: setGasLeft :: .PathExprSegments
            , GasId:Ptr , .PtrList
            )
        => ukmSetGasLeft(GasId)

    rule normalizedFunctionCall
            ( :: state_hooks :: setOutput :: .PathExprSegments
            , OutputId:Ptr , .PtrList
            )
        => ukmSetOutput(OutputId)

    rule
        <k>
            ukmSetStatus(ptrValue(_, u64(Value))) => ptrValue(null, tuple(.ValueList))
            ...
        </k>
        <ukm-status> _ => MInt2Unsigned(Value) </ukm-status>

    rule
        <k>
            ukmSetGasLeft(ptrValue(_, u64(Value))) => ptrValue(null, tuple(.ValueList))
            ...
        </k>
        <ukm-gas> _ => MInt2Unsigned(Value) </ukm-gas>

    rule ukmSetOutput(ptrValue(_, u64(BytesId))) => ukmSetOutput(ukmBytesId(BytesId))
    rule
        <k>
            ukmSetOutput(ukmBytesValue(Value:Bytes)) => ptrValue(null, tuple(.ValueList))
            ...
        </k>
        <ukm-output> _ => Value </ukm-output>

endmodule

```

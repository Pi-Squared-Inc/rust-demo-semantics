```k

module UKM-HOOKS-UKM-SYNTAX
    syntax UkmHook  ::= CallDataHook()
                      | CallerHook()
endmodule


module UKM-HOOKS-UKM
    imports private RUST-REPRESENTATION
    imports private RUST-SHARED-SYNTAX
    imports private UKM-HOOKS-UKM-SYNTAX

    syntax Identifier ::= "ukm"  [token]
                        | "CallData"  [token]
                        | "Caller"  [token]

    rule normalizedFunctionCall ( :: ukm :: CallData :: .PathExprSegments , .PtrList )
        => CallDataHook()
    rule normalizedFunctionCall ( :: ukm :: Caller :: .PathExprSegments , .PtrList )
        => CallerHook()
endmodule

```

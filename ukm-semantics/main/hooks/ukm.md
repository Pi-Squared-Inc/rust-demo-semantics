```k

module UKM-HOOKS-UKM-SYNTAX
    syntax UkmHook ::= CallDataHook()
endmodule


module UKM-HOOKS-UKM
    imports private RUST-REPRESENTATION
    imports private RUST-SHARED-SYNTAX
    imports private UKM-HOOKS-UKM-SYNTAX

    syntax Identifier ::= "ukm"  [token]
                        | "CallData"  [token]

    rule normalizedFunctionCall ( ukm :: CallData :: .PathExprSegments , .PtrList )
        => CallDataHook()
endmodule

```

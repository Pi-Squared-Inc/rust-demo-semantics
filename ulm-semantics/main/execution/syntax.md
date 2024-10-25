```k

module ULM-EXECUTION-SYNTAX
    imports BOOL-SYNTAX
    imports BYTES-SYNTAX
    imports INT-SYNTAX

    syntax ULMInstruction ::= ulmExecute(create: Bool, pgm:Bytes, accountId: Int, gas: Int)

endmodule

```

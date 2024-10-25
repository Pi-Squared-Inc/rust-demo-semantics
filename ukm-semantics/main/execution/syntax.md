```k

module UKM-EXECUTION-SYNTAX
    imports BOOL-SYNTAX
    imports BYTES-SYNTAX
    imports INT-SYNTAX

    syntax UKMInstruction ::= ukmExecute(create: Bool, pgm:Bytes, accountId: Int, gas: Int)

endmodule

```

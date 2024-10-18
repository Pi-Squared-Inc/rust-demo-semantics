```k

module UKM-DECODING-SYNTAX
    imports BYTES-SYNTAX
    imports LIST
    imports RUST-VALUE-SYNTAX

    syntax UKMInstruction ::= ukmDecodePreprocessedCell(Bytes)

    syntax KItem ::= decodeCallData(Bytes) [function] 
                   | decodeCallDataArguments(Bytes) [function] 

endmodule

```

```k

module UKM-ENCODING-SYNTAX
    imports BYTES-SYNTAX
    imports LIST
    imports RUST-VALUE-SYNTAX

    syntax UKMInstruction ::= "ukmEncodePreprocessedCell"

    // syntax Bytes ::= (CodingOperations, CodingOperations) [function, seqstrict]

    syntax KItem ::= "CodingOperations"
    syntax Bytes ::= encodeCallData (String, List, List) [function] //Function name, argument types, argument list
                   | encodeFunctionSignature (String, List, String) [function]
                   | encodeFunctionParams (List, List, Bytes) [function]
                   | convertToKBytes ( Value , String ) [function]

endmodule

```

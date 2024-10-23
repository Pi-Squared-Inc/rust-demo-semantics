```k

module UKM-ENCODING-SYNTAX
    imports BYTES-SYNTAX
    imports LIST
    imports RUST-REPRESENTATION

    syntax UKMInstruction ::= "ukmEncodePreprocessedCell"

    syntax Bytes ::= encodeCallData (String, List, List) [function] //Function name, argument types, argument list
                   | encodeFunctionSignature (String, List, String) [function]
                   | encodeFunctionSignature (StringOrError) [function]
                   | encodeFunctionParams (List, List, Bytes) [function]
                   | convertToKBytes ( Value , String ) [function]

    syntax String ::= encodeFunctionSignatureAsString(StringOrError) [function]

endmodule

```

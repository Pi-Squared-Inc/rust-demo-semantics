```k

module UKM-ENCODING-SYNTAX
    imports BYTES-SYNTAX
    imports LIST
    imports RUST-REPRESENTATION

    syntax UKMInstruction ::= "ukmEncodePreprocessedCell"
                            | ukmEncodedPreprocessedCell(Bytes)

    syntax Bytes ::= encodeCallData (String, List, List) [function] //Function name, argument types, argument list
                   | encodeFunctionSignature (String, List) [function]
                   | encodeFunctionSignatureHelper (List, String) [function]
                   | encodeFunctionParams (List, List, Bytes) [function]
                   | convertToKBytes ( Value , String ) [function]

    syntax StringOrError ::= encodeFunctionSignatureAsString(StringOrError) [function, total]

endmodule

```

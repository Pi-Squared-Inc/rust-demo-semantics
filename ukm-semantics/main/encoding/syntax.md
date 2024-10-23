```k

module UKM-ENCODING-SYNTAX
    imports BYTES-SYNTAX
    imports LIST
    imports RUST-REPRESENTATION
    imports UKM-REPRESENTATION

    syntax UKMInstruction ::= "ukmEncodePreprocessedCell"

    syntax BytesOrError ::= encodeFunctionSignatureAsBytes(StringOrError) [function, total]
    syntax Bytes ::= encodeHexBytes(String)  [function, total]

endmodule

module UKM-ENCODING-TESTING-SYNTAX
    imports BYTES-SYNTAX
    imports LIST
    imports RUST-REPRESENTATION

    syntax Bytes ::= encodeCallData (String, List, List) [function] //Function name, argument types, argument list
                   | encodeFunctionSignature (String, List, String) [function]
                   | encodeFunctionParams (List, List, Bytes) [function]
                   | convertToKBytes ( Value , String ) [function]

endmodule

```

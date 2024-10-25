```k

module ULM-ENCODING-SYNTAX
    imports BYTES-SYNTAX
    imports LIST
    imports RUST-REPRESENTATION

    syntax ULMInstruction ::= "ulmEncodePreprocessedCell"
                            | ulmEncodedPreprocessedCell(Bytes)

    // TODO: Make these functions total and returning BytesOrError
    syntax Bytes ::= encodeCallData (String, List, List) [function] //Function name, argument types, argument list
                   | encodeConstructorData (List, List) [function] // argument types, argument list
                   | encodeFunctionSignature (String, List) [function]
                   | encodeFunctionSignatureHelper (List, String) [function]
                   | encodeFunctionParams (List, List, Bytes) [function]

    syntax BytesOrError ::= encodeFunctionSignatureAsBytes(StringOrError) [function, total]

endmodule

module ULM-ENCODING-HELPER-SYNTAX
    imports BYTES-SYNTAX
    imports LIST
    imports RUST-REPRESENTATION
    imports ULM-REPRESENTATION

    // TODO: Make convertToKBytes total
    syntax Bytes ::= encodeHexBytes(String)  [function, total]
                   | convertToKBytes ( Value , String ) [function]

endmodule

```
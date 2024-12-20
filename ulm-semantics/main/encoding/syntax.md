```k

module ULM-ENCODING-SYNTAX
    imports BYTES-SYNTAX
    imports LIST
    imports RUST-REPRESENTATION
    imports ULM-ENCODING-ENCODE-VALUE-SYNTAX

    syntax BytesOrError ::= encodeFunctionSignatureAsBytes(StringOrError) [function, total]
    syntax IntOrError ::= encodeEventSignatureAsInt(StringOrError) [function, total]

    syntax BytesOrError  ::= methodSignature(String, NormalizedFunctionParameterList)  [function, total]
    syntax ValueOrError  ::= eventSignature(String, NormalizedFunctionParameterList)  [function, total]

    // assumes that bufferId points to an empty buffer.
    syntax NonEmptyStatementsOrError ::= codegenValuesEncoder(bufferId: Identifier, values: EncodeValues)  [function, total]

    syntax EncodeValue ::= paramToEncodeValue(NormalizedFunctionParameter)  [function, total]
    syntax EncodeValues ::= paramsToEncodeValues(NormalizedFunctionParameterList)  [function, total]
endmodule

module ULM-ENCODING-ENCODE-VALUE-SYNTAX
    imports RUST-SHARED-SYNTAX

    syntax EncodeValue ::= Expression ":" Type
    syntax EncodeValues ::= List{EncodeValue, ","}
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
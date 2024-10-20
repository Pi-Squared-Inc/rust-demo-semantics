```k

module UKM-DECODING-SYNTAX
    imports BYTES-SYNTAX
    imports INT-SYNTAX
    imports LIST
    imports RUST-VALUE-SYNTAX
    imports private RUST-REPRESENTATION

    syntax UKMDecodedCallArguments ::= UKMDecodedCallArgs( PathInExpression , List ) //List 
                                | decodeCallData(Bytes) [function] 

    syntax UKMInstruction ::= ukmDecodePreprocessedCell(Bytes)

    syntax NormalizedFunctionParameterList ::= loadArgumentsFromHash(Bytes) [function]
                                             | loadArgumentsFromHash(PathInExpression) [function]

    syntax List ::= decodeCallDataArguments(Bytes) [function] 
                   | decodeArguments(NormalizedFunctionParameterList, Bytes, List) [function]



    syntax PathInExpression ::= decodeFunctionSignature(Bytes) [function] 

    syntax PtrValue ::= convertKBytesToPtrValue(Type, Int) [function]

    syntax Int ::= sizeOfType(Type) [function]


endmodule

```
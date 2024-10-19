```k

module UKM-DECODING-SYNTAX
    imports BYTES-SYNTAX
    imports INT-SYNTAX
    imports LIST
    imports RUST-VALUE-SYNTAX
    imports private RUST-REPRESENTATION

    syntax UKMInstruction ::= ukmDecodePreprocessedCell(Bytes)
    //c6b6e1790000000000000000000000000000000000000000000000000000000000000001
    syntax NormalizedFunctionParameterList ::= loadArgumentsFromHash(Bytes) [function]
                                             | loadArgumentsFromHash(PathInExpression) [function]

    syntax KItem ::= decodeCallDataArguments(Bytes) [function] 
                   | decodeCallData(Bytes) [function] 
                   | decodeArguments(NormalizedFunctionParameterList, Bytes, List) [function]

    syntax PathInExpression ::= decodeFunctionSignature(Bytes) [function] 

    syntax PtrValue ::= convertKBytesToPtrValue(Type, Int) [function]

    syntax Int ::= sizeOfType(Type) [function]


endmodule

```

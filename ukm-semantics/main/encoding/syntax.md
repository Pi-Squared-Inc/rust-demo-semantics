```k

module UKM-ENCODING-SYNTAX
    imports BYTES-SYNTAX
    imports LIST
    imports RUST-REPRESENTATION

    syntax UKMInstruction ::= "ukmEncodePreprocessedCell"
    
    syntax Bytes ::= encodeFunctionSignature (PathInExpression, NormalizedFunctionParameterList) [function]

    syntax String ::= convertPathInExprToString(PathInExpression) [function]
    syntax List ::= convertFuncParamListToStrList(NormalizedFunctionParameterList, List) [function]

    syntax Bytes ::= encodeCallData (String, List, List) [function] //Function name, argument types, argument list
                   | encodeFunctionSignature (String, List, String) [function]
                   | encodeFunctionParams (List, List, Bytes) [function]
                   | convertToKBytes ( Value , String ) [function]

endmodule

```

```k

module UKM-CALLDATA-DECODER
    imports RUST-VALUE-SYNTAX
    imports UKM-DECODING-SYNTAX
    imports BYTES-HOOKED
    imports BYTES-SYNTAX
    imports private COMMON-K-CELL
    imports private RUST-PREPROCESSING-CONFIGURATION
    imports private UKM-PREPROCESSING-CONFIGURATION
    imports private RUST-REPRESENTATION
    imports INT

    rule decodeCallData(D:Bytes) => 
            UKMDecodedCallArgs(decodeFunctionSignature(substrBytes(D, 0, 8)), decodeArguments(loadArgumentsFromHash(substrBytes(D, 0, 8)), substrBytes(D, 8, lengthBytes(D)), .List) )

    rule [[ decodeFunctionSignature(FuncSigHash:Bytes) => P ]]
        <ukm-method-hash-to-signatures>
            ... FuncSigHash |-> P:PathInExpression ...
        </ukm-method-hash-to-signatures>

    rule [[ loadArgumentsFromHash(FuncSigHash:Bytes) => loadArgumentsFromHash(P) ]]
        <ukm-method-hash-to-signatures>
            ... FuncSigHash |-> P:PathInExpression ...
        </ukm-method-hash-to-signatures>
        
    rule [[ loadArgumentsFromHash(Method:PathInExpression) => L ]]
        <method-name> Method </method-name>
        <method-params> (self : $selftype), L:NormalizedFunctionParameterList </method-params>
        
    rule decodeArguments(((_ : T:Type), R):NormalizedFunctionParameterList, D:Bytes, L:List) => 
        decodeArguments(R, substrBytes(D, 0, sizeOfType(T)), 
            ListItem(convertKBytesToPtrValue (T, Bytes2Int ( substrBytes(D, 0, sizeOfType(T)), BE, Unsigned ) ) ) L )

    rule decodeArguments(.NormalizedFunctionParameterList, _, L:List) => L

    rule convertKBytesToPtrValue(u32, I:Int) => ptrValue(null, u32(Int2MInt(I)))
    rule convertKBytesToPtrValue(i32, I:Int) => ptrValue(null, i32(Int2MInt(I)))
    rule convertKBytesToPtrValue(i64, I:Int) => ptrValue(null, i64(Int2MInt(I)))
    rule convertKBytesToPtrValue(u64, I:Int) => ptrValue(null, u64(Int2MInt(I)))
    rule convertKBytesToPtrValue(u128, I:Int) => ptrValue(null, u128(Int2MInt(I)))

    rule sizeOfType(i32)  => 32
    rule sizeOfType(u32)  => 32
    rule sizeOfType(u64)  => 64
    rule sizeOfType(i64)  => 64
    rule sizeOfType(u128) => 128    
endmodule
```
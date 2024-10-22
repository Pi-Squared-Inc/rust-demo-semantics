```k

module UKM-CALLDATA-DECODER
    imports RUST-VALUE-SYNTAX
    imports UKM-DECODING-SYNTAX
    imports BYTES-HOOKED
    imports BYTES-SYNTAX
    imports private COMMON-K-CELL
    imports private RUST-PREPROCESSING-CONFIGURATION
    imports private UKM-PREPROCESSING-CONFIGURATION
    imports private RUST-EXECUTION-CONFIGURATION
    imports private RUST-REPRESENTATION
    imports private RUST-CONVERSIONS-SYNTAX
    imports INT

    rule decodeCallData(D:Bytes) => 
            UKMDecodedCallData1(decodeFunctionSignature(substrBytes(D, 0, 8)), decodeArguments(loadArgumentsFromHash(substrBytes(D, 0, 8)), substrBytes(D, 8, lengthBytes(D)), .List) )

    // TODO: Self is being assigned to an integer 0. This should be fixed in case we need
    // to make references to self within rust contracts
    rule <k> UKMDecodedCallData1(P:PathInExpression, L:List)
                => UKMDecodedCallData1(P, L)
                    ~> UKMDecodedCallData2(P, ListItem(NextId)) 
        ... </k> 
        <next-value-id> NextId:Int => NextId +Int 1 </next-value-id>
        <values> Values:Map => Values[NextId <- u64(Int2MInt(0))] </values> [priority(80)] 


    rule <k> UKMDecodedCallData1(P:PathInExpression, L:List ListItem(ptrValue(_, V)))
            ~> UKMDecodedCallData2(P:PathInExpression, PL:List)
                => UKMDecodedCallData1(P, L)
                    ~> UKMDecodedCallData2(P, ListItem(NextId) PL)  
        ... </k> 
        <next-value-id> NextId:Int => NextId +Int 1 </next-value-id>
        <values> Values:Map => Values[NextId <- V] </values> [priority(70)]

    rule <k> UKMDecodedCallData1(_:PathInExpression, .List)
                => .K ... </k>         
        
    rule <k> UKMDecodedCallData2(P:PathInExpression, L:List)
                => UKMDecodedCallData(P:PathInExpression, listToPtrList(L)) ... </k>         

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
        decodeArguments(R, substrBytes(D, 0, 32), 
            ListItem( convertKBytesToPtrValue (T, Bytes2Int ( substrBytes(D, 0, 32), BE, Unsigned ) ) ) L ) 

    rule decodeArguments(.NormalizedFunctionParameterList, _, L:List) => L

    rule convertKBytesToPtrValue(u32, I:Int) => ptrValue(null, u32(Int2MInt(I)))
    rule convertKBytesToPtrValue(i32, I:Int) => ptrValue(null, i32(Int2MInt(I)))
    rule convertKBytesToPtrValue(i64, I:Int) => ptrValue(null, i64(Int2MInt(I)))
    rule convertKBytesToPtrValue(u64, I:Int) => ptrValue(null, u64(Int2MInt(I)))
    rule convertKBytesToPtrValue(u128, I:Int) => ptrValue(null, u128(Int2MInt(I)))
endmodule
```
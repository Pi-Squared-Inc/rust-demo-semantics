```k
requires "plugin/krypto.md"

module UKM-CALLDATA-ENCODER
    imports private COMMON-K-CELL
    imports private UKM-ENCODING-SYNTAX
    imports private UKM-PREPROCESSING-ENDPOINTS
    imports STRING
    imports BYTES
    imports INT
    imports KRYPTO

    syntax String ::= Identifier2String(Identifier)  [function, total, hook(STRING.token2string)]
                    | Type2String(Type)  [function, total, hook(STRING.token2string)]

    rule encodeFunctionSignature (P:PathInExpression, N:NormalizedFunctionParameterList) => 
                encodeFunctionSignature(convertPathInExprToString(P), convertFuncParamListToStrList(N, .List), "")

    rule convertPathInExprToString(( :: _I:Identifier :: R:PathExprSegments):PathInExpression ) =>
            convertPathInExprToString(R) [priority(80)]
    rule convertPathInExprToString(( _I:Identifier :: R:PathExprSegments):PathInExpression ) =>
            convertPathInExprToString(R) [priority(80)]
    rule convertPathInExprToString(( I:Identifier :: .PathExprSegments):PathInExpression ) =>
            Identifier2String(I) [priority(70)]
            
    rule convertFuncParamListToStrList(((self : _), N:NormalizedFunctionParameterList), .List) => 
        convertFuncParamListToStrList( N, .List) [priority(60)]
    rule convertFuncParamListToStrList(((_ : T:Type), N:NormalizedFunctionParameterList), L:List) =>
        convertFuncParamListToStrList(N, L ListItem(signatureType(T))) [priority(70)]
    rule convertFuncParamListToStrList(.NormalizedFunctionParameterList, L:List) => L

    rule encodeCallData(FN:String, FAT:List, FAL:List) => 
            encodeFunctionSignature(FN, FAT, "") +Bytes encodeFunctionParams(FAL, FAT, b"")  

    // Function signature encoding
    rule encodeFunctionSignature(FuncName:String, RL:List, "") => 
            encodeFunctionSignature("", RL:List, FuncName +String "(") [priority(40)]
        
    rule encodeFunctionSignature("", ListItem(FuncParam:String) RL:List, FS) => 
                encodeFunctionSignature("", RL, FS +String FuncParam +String ",") [owise]
    
    // The last param does not have a follow up comma
    rule encodeFunctionSignature("", ListItem(FuncParam:String) .List, FS) => 
                encodeFunctionSignature("", .List, FS +String FuncParam ) 
         
    rule encodeFunctionSignature("", .List, FS) => String2Bytes(substrString(Keccak256(String2Bytes(FS  +String ")")), 0, 8)) 

    rule encodeFunctionSignatureAsString(FS) => substrString(Keccak256(String2Bytes(FS)), 0, 8)
    rule encodeFunctionSignature(FS:String:StringOrError) => String2Bytes(substrString(Keccak256(String2Bytes(FS)), 0, 8)) 

    // Function parameters encoding
    rule encodeFunctionParams(ListItem(V:Value) ARGS:List, ListItem(T:String) PTYPES:List, B:Bytes) =>
            encodeFunctionParams(ARGS:List, PTYPES:List, B:Bytes +Bytes convertToKBytes(V, T))

    rule encodeFunctionParams(.List, .List, B:Bytes) => B


    // Encoding of individual types

    rule convertToKBytes(i8(V) , "int8") => Int2Bytes(32, MInt2Signed(V), BE:Endianness) 
    rule convertToKBytes(u8(V) , "uint8") => Int2Bytes(32, MInt2Unsigned(V), BE:Endianness) 
    rule convertToKBytes(i16(V), "int16") => Int2Bytes(32, MInt2Signed(V), BE:Endianness) 
    rule convertToKBytes(u16(V), "uint16") => Int2Bytes(32, MInt2Unsigned(V), BE:Endianness) 
    rule convertToKBytes(i32(V), "int32") => Int2Bytes(32, MInt2Signed(V), BE:Endianness) 
    rule convertToKBytes(u32(V), "uint32") => Int2Bytes(32, MInt2Unsigned(V), BE:Endianness) 
    rule convertToKBytes(i64(V), "int64") => Int2Bytes(32, MInt2Signed(V), BE:Endianness) 
    rule convertToKBytes(u64(V), "uint64") => Int2Bytes(32, MInt2Unsigned(V), BE:Endianness) 
    rule convertToKBytes(u128(V), "uint128") => Int2Bytes(32, MInt2Unsigned(V), BE:Endianness) 
    rule convertToKBytes(true,  "bool") => Int2Bytes(32, 1, BE:Endianness) 
    rule convertToKBytes(false, "bool") => Int2Bytes(32, 0, BE:Endianness)
    rule convertToKBytes(u256(V), "uint256") => Int2Bytes(32, MInt2Unsigned(V), BE:Endianness) 
    rule convertToKBytes(u160(V), "uint160") => Int2Bytes(32, MInt2Unsigned(V), BE:Endianness)  
    rule convertToKBytes(u160(V), "address") => Int2Bytes(32, MInt2Unsigned(V), BE:Endianness)  

endmodule

```
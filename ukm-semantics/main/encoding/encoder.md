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

    // TODO: Properly encode the call data. Currently, we are returning the
    // representation of the encoded function signature from a string using
    // two characters to represent a byte in hexadecimal. We need to return the
    // correct four bytes representation of signature.
    // TODO: it may be worth extracting the substrString(Keccak256(String2Bytes(FS)), 0, 8) 
    // thing to a function that takes a String and produces a String or Bytes (as opposed to
    // taking a StringOrError as below) (perhaps with an encodeAsBytes(...) on top of it) and 
    // then use it here and in the rules below.
    rule encodeCallData(FN:String, FAT:List, FAL:List) => 
            encodeFunctionSignature(FN, FAT) +Bytes encodeFunctionParams(FAL, FAT, b"")  

    // Function signature encoding
    rule encodeFunctionSignature(FuncName:String, RL:List) => 
            encodeFunctionSignatureHelper(RL:List, FuncName +String "(") [priority(40)]
        
    rule encodeFunctionSignatureHelper(ListItem(FuncParam:String) RL:List, FS) => 
                encodeFunctionSignatureHelper(RL, FS +String FuncParam +String ",") [owise]
    
    // The last param does not have a follow up comma
    rule encodeFunctionSignatureHelper(ListItem(FuncParam:String) .List, FS) => 
                encodeFunctionSignatureHelper(.List, FS +String FuncParam ) 
         
    rule encodeFunctionSignatureHelper(.List, FS) => String2Bytes(substrString(Keccak256(String2Bytes(FS  +String ")")), 0, 8)) 

    // TODO: Implement helper functions and break down encodeFunctionSignatureAsString  
    // into smaller productions. Trigger errors for each of the 
    // possible functions which can be failure causes.
    rule encodeFunctionSignatureAsString(FS) => substrString(Keccak256(String2Bytes(FS)), 0, 8)
    rule encodeFunctionSignatureAsString(FS) => error("Failed to apply the Keccak256 of function signature.", FS) [owise]

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
```k
requires "plugin/krypto.md"

module ULM-ENCODING-HELPER
    imports private BYTES
    imports private INT-SYNTAX
    imports private KRYPTO
    imports private STRING
    imports private ULM-ENCODING-HELPER-SYNTAX

    // TODO: Error for argument of length 1 or string not hex
    rule encodeHexBytes(_:String) => .Bytes
        [owise]
    rule encodeHexBytes(S:String)
        => Int2Bytes(2, String2Base(substrString(S, 0, 2), 16), BE)
            +Bytes encodeHexBytes(substrString(S, 2, lengthString(S)))
        requires 2 <=Int lengthString(S) andBool isHex(substrString(S, 0, 2), 0)

    syntax Bool ::= isHex(String, idx:Int)  [function, total]
    rule isHex(S:String, I:Int) => true
        requires I <Int 0 orBool lengthString(S) <=Int I
    rule isHex(S:String, I:Int)
        => isHexDigit(substrString(S, I, I +Int 1)) andBool isHex(S, I +Int 1)
        requires 0 <=Int I andBool I <Int lengthString(S)

    syntax Bool ::= isHexDigit(String)  [function, total]
    rule isHexDigit(S)
        => ("0" <=String S andBool S <=String "9")
            orBool ("a" <=String S andBool S <=String "f")
            orBool ("A" <=String S andBool S <=String "F")

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

module ULM-CALLDATA-ENCODER
    imports private BYTES
    imports private INT-SYNTAX
    imports private KRYPTO
    imports private STRING
    imports private ULM-ENCODING-SYNTAX
    imports private ULM-ENCODING-HELPER-SYNTAX
    imports private ULM-ENCODING-HELPER

    rule encodeFunctionSignatureAsBytes(FS)
        => encodeHexBytes(substrString(Keccak256(String2Bytes(FS)), 0, 8))
    rule encodeFunctionSignatureAsBytes(E:SemanticsError) => E

    // TODO: it may be worth extracting the substrString(Keccak256(String2Bytes(FS)), 0, 8) 
    // thing to a function that takes a String and produces a String or Bytes (as opposed to
    // taking a StringOrError as below) (perhaps with an encodeAsBytes(...) on top of it) and 
    // then use it here and in the rules below.
    rule encodeCallData(FN:String, FAT:List, FAL:List) => 
           encodeFunctionSignature(FN, FAT) +Bytes encodeFunctionParams(FAL, FAT, b"")  
    rule encodeConstructorData(FAT:List, FAL:List) => 
           encodeFunctionParams(FAL, FAT, b"")  

    // Function signature encoding
    rule encodeFunctionSignature(FuncName:String, RL:List) => 
            encodeFunctionSignatureHelper(RL:List, FuncName +String "(") [priority(40)]
        
    rule encodeFunctionSignatureHelper(ListItem(FuncParam:String) RL:List, FS) => 
            encodeFunctionSignatureHelper(RL, FS +String FuncParam +String ",") [owise]
    
    // The last param does not have a follow up comma
    rule encodeFunctionSignatureHelper(ListItem(FuncParam:String) .List, FS) => 
            encodeFunctionSignatureHelper(.List, FS +String FuncParam ) 

    rule encodeFunctionSignatureHelper(.List, FS) => encodeHexBytes(substrString(Keccak256(String2Bytes(FS  +String ")")), 0, 8)) 

    // Function parameters encoding
    rule encodeFunctionParams(ListItem(V:Value) ARGS:List, ListItem(T:String) PTYPES:List, B:Bytes) =>
            encodeFunctionParams(ARGS:List, PTYPES:List, B:Bytes +Bytes convertToKBytes(V, T))

    rule encodeFunctionParams(.List, .List, B:Bytes) => B
endmodule

```
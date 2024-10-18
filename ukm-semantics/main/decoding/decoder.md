```k

module UKM-CALLDATA-DECODER
    imports RUST-VALUE-SYNTAX
    imports UKM-DECODING-SYNTAX
    imports BYTES-HOOKED
    imports BYTES-SYNTAX
    imports INT

    // Convert the bytes to integer and do a bit shifting operation to get the values
    rule decodeCallData(D:Bytes) =>
        substrBytes(D, 0, 8)
        
        // Int2Bytes(64:Int, 
        //     (Bytes2Int(D:Bytes, BE:Endianness, Unsigned:Signedness) >>Int (lengthBytes(D) -Int 4)):Int,
        // BE:Endianness) 
        // (Bytes2Int(D:Bytes, BE:Endianness, Unsigned:Signedness)
        // ( Int2Bytes(D[0]) +Bytes Int2Bytes(D[1]) +Bytes Int2Bytes(D[2]) +Bytes Int2Bytes(D[3]), decodeCallDataArguments(D:Bytes))



endmodule
```
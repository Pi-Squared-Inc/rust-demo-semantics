```k

module UKM-HOOKS-BYTES-CONFIGURATION
    imports INT-SYNTAX
    imports MAP

    configuration
        <ukm-bytes>
            <ukm-bytes-buffers>
                .Map  // Int to Bytes
            </ukm-bytes-buffers>
            <ukm-bytes-next-id>
                0
            </ukm-bytes-next-id>
        </ukm-bytes>
endmodule

module UKM-HOOKS-BYTES-SYNTAX
    imports BYTES-SYNTAX
    syntax Expression ::= ukmBytesNew(Bytes)
endmodule

module UKM-HOOKS-BYTES
    imports private BYTES
    imports private COMMON-K-CELL
    imports private RUST-HELPERS
    imports private RUST-REPRESENTATION
    imports private UKM-HOOKS-BYTES-CONFIGURATION
    imports private UKM-HOOKS-BYTES-SYNTAX
    imports private UKM-REPRESENTATION


    syntax Identifier ::= "bytes_hooks"  [token]
                        | "empty"  [token]
                        | "length"  [token]
                        | "append_u128"  [token]
                        | "append_u64"  [token]
                        | "append_u32"  [token]
                        | "append_u16"  [token]
                        | "append_u8"  [token]
                        | "append_str"  [token]
                        | "decode_u128"  [token]
                        | "decode_u64"  [token]
                        | "decode_u32"  [token]
                        | "decode_u16"  [token]
                        | "decode_u8"  [token]
                        | "decode_str"  [token]

    rule
        <k>
            normalizedFunctionCall
                ( :: bytes_hooks :: empty :: .PathExprSegments
                , .PtrList
                )
            => ptrValue(null, u64(Int2MInt(NextId)))
            ...
        </k>
        <ukm-bytes-buffers>
            M => M[NextId <- b""]
        </ukm-bytes-buffers>
        <ukm-bytes-next-id>
            NextId:Int => NextId +Int 1
        </ukm-bytes-next-id>
        requires notBool uoverflowMInt(64, NextId)

    rule
        normalizedFunctionCall
            ( :: bytes_hooks :: length :: .PathExprSegments
            , BufferIdId:Ptr, .PtrList
            )
        => ukmBytesLength(BufferIdId)

    rule
        normalizedFunctionCall
            ( :: bytes_hooks :: append_u128 :: .PathExprSegments
            , BufferIdId:Ptr, IntId:Ptr, .PtrList
            )
        => ukmBytesAppendInt(BufferIdId, IntId)

    rule
        normalizedFunctionCall
            ( :: bytes_hooks :: append_u64 :: .PathExprSegments
            , BufferIdId:Ptr, IntId:Ptr, .PtrList
            )
        => ukmBytesAppendInt(BufferIdId, IntId)

    rule
        normalizedFunctionCall
            ( :: bytes_hooks :: append_u32 :: .PathExprSegments
            , BufferIdId:Ptr, IntId:Ptr, .PtrList
            )
        => ukmBytesAppendInt(BufferIdId, IntId)

    rule
        normalizedFunctionCall
            ( :: bytes_hooks :: append_u16 :: .PathExprSegments
            , BufferIdId:Ptr, IntId:Ptr, .PtrList
            )
        => ukmBytesAppendInt(BufferIdId, IntId)

    rule
        normalizedFunctionCall
            ( :: bytes_hooks :: append_u8 :: .PathExprSegments
            , BufferIdId:Ptr, IntId:Ptr, .PtrList
            )
        => ukmBytesAppendInt(BufferIdId, IntId)

    rule
        normalizedFunctionCall
            ( :: bytes_hooks :: append_str :: .PathExprSegments
            , BufferIdId:Ptr, StrId:Ptr, .PtrList
            )
        => ukmBytesAppendStr(BufferIdId, StrId)

    rule
        normalizedFunctionCall
            ( :: bytes_hooks :: decode_u128 :: .PathExprSegments
            , BufferIdId:Ptr, .PtrList
            )
        => ukmBytesDecode(BufferIdId, u32)

    rule
        normalizedFunctionCall
            ( :: bytes_hooks :: decode_u64 :: .PathExprSegments
            , BufferIdId:Ptr, .PtrList
            )
        => ukmBytesDecode(BufferIdId, u64)

    rule
        normalizedFunctionCall
            ( :: bytes_hooks :: decode_u32 :: .PathExprSegments
            , BufferIdId:Ptr, .PtrList
            )
        => ukmBytesDecode(BufferIdId, u32)

    rule
        normalizedFunctionCall
            ( :: bytes_hooks :: decode_u16 :: .PathExprSegments
            , BufferIdId:Ptr, .PtrList
            )
        => ukmBytesDecode(BufferIdId, u16)

    rule
        normalizedFunctionCall
            ( :: bytes_hooks :: decode_u8 :: .PathExprSegments
            , BufferIdId:Ptr, .PtrList
            )
        => ukmBytesDecode(BufferIdId, u8)

    rule
        normalizedFunctionCall
            ( :: bytes_hooks :: decode_str :: .PathExprSegments
            , BufferIdId:Ptr, .PtrList
            )
        => ukmBytesDecode(BufferIdId, str)

    // ---------------------------------------

    rule
        <k>
            ukmBytesId(BytesId) => ukmBytesValue(Value)
            ...
        </k>
        <ukm-bytes-buffers>
            MInt2Unsigned(BytesId) |-> Value:Bytes
            ...
        </ukm-bytes-buffers>

    syntax UKMInstruction ::= ukmBytesLength(Expression)  [strict(1)]
                            | ukmBytesLength(UkmExpression)  [strict(1)]
                            | ukmBytesAppendInt(Expression, Expression)  [seqstrict]
                            | ukmBytesAppendInt(UkmExpression, Int)  [strict(1)]
                            | ukmBytesAppendStr(Expression, Expression)  [seqstrict]
                            | ukmBytesAppendBytes(UkmExpression, Bytes)  [strict(1)]
                            | ukmBytesAppendLenAndBytes(Bytes, Bytes)
                            | ukmBytesDecode(Expression, Type)  [strict(1)]
                            | ukmBytesDecode(UkmExpression, Type)  [strict(1)]
                            | ukmBytesDecode(Int, Bytes, Type)
                            | ukmBytesDecodeInt(Int, Bytes, Type)
                            | ukmBytesDecode(ValueOrError, Bytes)

    rule
        <k>
            ukmBytesNew(B:Bytes)
            => ptrValue(null, u64(Int2MInt(NextId)))
            ...
        </k>
        <ukm-bytes-buffers>
            M => M[NextId <- B]
        </ukm-bytes-buffers>
        <ukm-bytes-next-id>
            NextId:Int => NextId +Int 1
        </ukm-bytes-next-id>
        requires notBool uoverflowMInt(64, NextId)

    rule ukmBytesLength(ptrValue(_, u64(BytesId))) => ukmBytesLength(ukmBytesId(BytesId))
    rule ukmBytesLength(ukmBytesValue(Value:Bytes))
        => ptrValue(null, u32(Int2MInt(lengthBytes(Value))))
        requires notBool uoverflowMInt(32, lengthBytes(Value))

    rule ukmBytesAppendInt(ptrValue(_, u64(BytesId)), ptrValue(_, u128(Value)))
        => ukmBytesAppendInt(ukmBytesId(BytesId), MInt2Unsigned(Value))
    rule ukmBytesAppendInt(ptrValue(_, u64(BytesId)), ptrValue(_, u64(Value)))
        => ukmBytesAppendInt(ukmBytesId(BytesId), MInt2Unsigned(Value))
    rule ukmBytesAppendInt(ptrValue(_, u64(BytesId)), ptrValue(_, u32(Value)))
        => ukmBytesAppendInt(ukmBytesId(BytesId), MInt2Unsigned(Value))
    rule ukmBytesAppendInt(ptrValue(_, u64(BytesId)), ptrValue(_, u16(Value)))
        => ukmBytesAppendInt(ukmBytesId(BytesId), MInt2Unsigned(Value))
    rule ukmBytesAppendInt(ptrValue(_, u64(BytesId)), ptrValue(_, u8(Value)))
        => ukmBytesAppendInt(ukmBytesId(BytesId), MInt2Unsigned(Value))

    rule ukmBytesAppendInt(ukmBytesValue(B:Bytes), Value:Int)
        => ukmBytesAppendLenAndBytes(B, Int2Bytes(Value, BE, Unsigned))

    rule ukmBytesAppendStr(ptrValue(_, u64(BytesId)), ptrValue(_, Value:String))
        => ukmBytesAppendBytes(ukmBytesId(BytesId), String2Bytes(Value))

    rule ukmBytesAppendBytes(ukmBytesValue(B:Bytes), Value:Bytes)
        => ukmBytesAppendLenAndBytes(B, Value)

    rule ukmBytesAppendLenAndBytes(First:Bytes, Second:Bytes)
        => ukmBytesNew(First +Bytes Int2Bytes(2, lengthBytes(Second), BE) +Bytes Second)
        requires lengthBytes(Second) <Int (1 <<Int 16)

    rule ukmBytesDecode(ptrValue(_, u64(BytesId)), T:Type)
        => ukmBytesDecode(ukmBytesId(BytesId), T:Type)
    rule ukmBytesDecode(ukmBytesValue(B:Bytes), T:Type)
        => ukmBytesDecode
            ( Bytes2Int(substrBytes(B, 0, 2), BE, Unsigned)
            , substrBytes(B, 2, lengthBytes(B))
            , T:Type
            )
        requires 2 <=Int lengthBytes(B)
    rule ukmBytesDecode(Len:Int, B:Bytes, T:Type)
        => ukmBytesDecodeInt
            ( Bytes2Int(substrBytes(B, 0, Len), BE, Unsigned)
            , substrBytes(B, Len, lengthBytes(B))
            , T:Type
            )
        requires Len <=Int lengthBytes(B) andBool isUnsignedInt(T)
    rule ukmBytesDecode(Len:Int, B:Bytes, T:Type)
        => ukmBytesDecodeInt
            ( Bytes2Int(substrBytes(B, 0, Len), BE, Signed)
            , substrBytes(B, Len, lengthBytes(B))
            , T:Type
            )
        requires Len <=Int lengthBytes(B) andBool isSignedInt(T)
    rule ukmBytesDecode(Len:Int, B:Bytes, str)
        => ukmBytesDecode
            ( Bytes2String(substrBytes(B, 0, Len))
            , substrBytes(B, Len, lengthBytes(B))
            )
        requires Len <=Int lengthBytes(B)
    rule ukmBytesDecodeInt(Value:Int, B:Bytes, T:Type)
        => ukmBytesDecode(integerToValue(Value, T), B)
    rule ukmBytesDecode(Value:Value, B:Bytes)
        => tupleExpression(ukmBytesNew(B) , ptrValue(null, Value) , .TupleElementsNoEndComma)
endmodule

```

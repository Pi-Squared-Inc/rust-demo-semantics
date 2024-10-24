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

module UKM-HOOKS-BYTES
    imports private BYTES
    imports private COMMON-K-CELL
    imports private K-EQUAL-SYNTAX
    imports private RUST-HELPERS
    imports private RUST-REPRESENTATION
    imports private UKM-HOOKS-BYTES-CONFIGURATION
    imports private UKM-REPRESENTATION


    syntax Identifier ::= "bytes_hooks"  [token]
                        | "empty"  [token]
                        | "length"  [token]
                        | "equals"  [token]
                        | "append_bool"  [token]
                        | "append_u256"  [token]
                        | "append_u160"  [token]
                        | "append_u128"  [token]
                        | "append_u64"  [token]
                        | "append_u32"  [token]
                        | "append_u16"  [token]
                        | "append_u8"  [token]
                        | "append_str"  [token]
                        | "decode_u256"  [token]
                        | "decode_u160"  [token]
                        | "decode_u128"  [token]
                        | "decode_u64"  [token]
                        | "decode_u32"  [token]
                        | "decode_u16"  [token]
                        | "decode_u8"  [token]
                        | "decode_str"  [token]
                        | "hash"  [token]
                        | "decode_signature"  [token]

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
            ( :: bytes_hooks :: equals :: .PathExprSegments
            , BufferIdId1:Ptr, BufferIdId2:Ptr, .PtrList
            )
        => ukmBytesEquals(BufferIdId1, BufferIdId2)

    rule
        normalizedFunctionCall
            ( :: bytes_hooks :: append_u256 :: .PathExprSegments
            , BufferIdId:Ptr, IntId:Ptr, .PtrList
            )
        => ukmBytesAppendInt(BufferIdId, IntId)

    rule
        normalizedFunctionCall
            ( :: bytes_hooks :: append_u160 :: .PathExprSegments
            , BufferIdId:Ptr, IntId:Ptr, .PtrList
            )
        => ukmBytesAppendInt(BufferIdId, IntId)

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
            ( :: bytes_hooks :: append_bool :: .PathExprSegments
            , BufferIdId:Ptr, IntId:Ptr, .PtrList
            )
        => ukmBytesAppendBool(BufferIdId, IntId)

    rule
        normalizedFunctionCall
            ( :: bytes_hooks :: append_str :: .PathExprSegments
            , BufferIdId:Ptr, StrId:Ptr, .PtrList
            )
        => ukmBytesAppendStr(BufferIdId, StrId)

    rule
        normalizedFunctionCall
            ( :: bytes_hooks :: decode_u256 :: .PathExprSegments
            , BufferIdId:Ptr, .PtrList
            )
        => ukmBytesDecode(BufferIdId, u256)

    rule
        normalizedFunctionCall
            ( :: bytes_hooks :: decode_u160 :: .PathExprSegments
            , BufferIdId:Ptr, .PtrList
            )
        => ukmBytesDecode(BufferIdId, u160)

    rule
        normalizedFunctionCall
            ( :: bytes_hooks :: decode_u128 :: .PathExprSegments
            , BufferIdId:Ptr, .PtrList
            )
        => ukmBytesDecode(BufferIdId, u128)

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

     rule
        normalizedFunctionCall
            ( :: bytes_hooks :: hash :: .PathExprSegments
            , BufferIdId:Ptr, .PtrList
            )
        => ukmBytesHash(BufferIdId)

    rule
        normalizedFunctionCall
            ( :: bytes_hooks :: decode_signature :: .PathExprSegments
            , BufferIdId:Ptr, .PtrList
            )
        => ukmBytesDecodeBytes(BufferIdId, 8)
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
                            | ukmBytesEquals(Expression, Expression)  [seqstrict]
                            | ukmBytesEquals(UkmExpression, UkmExpression)  [seqstrict]
                            | ukmBytesAppendInt(Expression, Expression)  [seqstrict]
                            | ukmBytesAppendInt(UkmExpression, Int)  [strict(1)]
                            | ukmBytesAppendBool(Expression, Expression)  [seqstrict]
                            | ukmBytesAppendStr(Expression, Expression)  [seqstrict]
                            | ukmBytesAppendBytes(UkmExpression, Bytes)  [strict(1)]
                            | ukmBytesAppendLenAndBytes(UkmExpression, Bytes)  [strict(1)]
                            | ukmBytesDecode(Expression, Type)  [strict(1)]
                            | ukmBytesDecode(UkmExpression, Type)  [strict(1)]
                            | ukmBytesDecodeBytes(Expression, Int)  [strict(1)]
                            | ukmBytesDecodeBytes(UkmExpression, Int)  [strict(1)]
                            | ukmBytesDecode(Int, Bytes, Type)
                            | ukmBytesDecodeInt(Int, Bytes, Type)
                            | ukmBytesDecodeStr(Int, Bytes)
                            | ukmBytesDecode(ValueOrError, Bytes)
                            | ukmBytesHash(Expression)  [strict(1)]
                            | ukmBytesHash(UkmExpression)  [strict(1)]

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

    rule ukmBytesEquals(ptrValue(_, u64(BytesId1)), ptrValue(_, u64(BytesId2)))
        => ukmBytesEquals(ukmBytesId(BytesId1), ukmBytesId(BytesId2))
    rule ukmBytesEquals(ukmBytesValue(Value1:Bytes), ukmBytesValue(Value2:Bytes))
        => ptrValue(null, Value1 ==K Value2)

    rule ukmBytesAppendInt(ptrValue(_, u64(BytesId)), ptrValue(_, u256(Value)))
        => ukmBytesAppendInt(ukmBytesId(BytesId), MInt2Unsigned(Value))
    rule ukmBytesAppendInt(ptrValue(_, u64(BytesId)), ptrValue(_, u160(Value)))
        => ukmBytesAppendInt(ukmBytesId(BytesId), MInt2Unsigned(Value))
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
        => ukmBytesNew(B +Bytes Int2Bytes(32, Value, BE))

    rule ukmBytesAppendBool(ptrValue(P, u64(BytesId)), ptrValue(_, false))
        => ukmBytesAppendInt(ptrValue(P, u64(BytesId)), ptrValue(null, u8(0p8)))
    rule ukmBytesAppendBool(ptrValue(P, u64(BytesId)), ptrValue(_, true))
        => ukmBytesAppendInt(ptrValue(P, u64(BytesId)), ptrValue(null, u8(1p8)))

    // TODO: This can create key ambiguity for storage
    rule ukmBytesAppendStr(ptrValue(_, u64(BytesId)), ptrValue(_, Value:String))
        => ukmBytesAppendLenAndBytes(ukmBytesId(BytesId), String2Bytes(Value))

    rule ukmBytesAppendBytes(ukmBytesValue(B:Bytes), Value:Bytes)
        => ukmBytesNew(B +Bytes Value)

    rule ukmBytesAppendLenAndBytes(ukmBytesValue(First:Bytes), Second:Bytes)
        => ukmBytesNew(First +Bytes Int2Bytes(2, lengthBytes(Second), BE) +Bytes Second)
        requires lengthBytes(Second) <Int (1 <<Int 16)

    rule ukmBytesDecodeBytes(ptrValue(_, u64(BytesId)), L:Int)
        => ukmBytesDecodeBytes(ukmBytesId(BytesId), L:Int)
    rule ukmBytesDecodeBytes(ukmBytesValue(B:Bytes), L:Int) 
        => tupleExpression
            ( ukmBytesNew(substrBytes(B, L, lengthBytes(B)))
            , ukmBytesNew(substrBytes(B, 0, L))
            , .TupleElementsNoEndComma
            )
        requires L <=Int lengthBytes(B)

    rule ukmBytesDecode(ptrValue(_, u64(BytesId)), T:Type)
        => ukmBytesDecode(ukmBytesId(BytesId), T:Type)
    rule ukmBytesDecode(ukmBytesValue(B:Bytes), T:Type)
        => ukmBytesDecode
            ( integerToValue(Bytes2Int(substrBytes(B, 0, 32), BE, Unsigned), T)
            , substrBytes(B, 32, lengthBytes(B))
            )
        requires isUnsignedInt(T) andBool 32 <=Int lengthBytes(B)
    rule ukmBytesDecode(ukmBytesValue(B:Bytes), T:Type)
        => ukmBytesDecode
            ( integerToValue(Bytes2Int(substrBytes(B, 0, 32), BE, Signed), T)
            , substrBytes(B, 32, lengthBytes(B))
            )
        requires isSignedInt(T) andBool 32 <=Int lengthBytes(B)
    rule ukmBytesDecode(ukmBytesValue(B:Bytes), str)
        => ukmBytesDecodeStr
            ( Bytes2Int(substrBytes(B, 0, 2), BE, Signed)
            , substrBytes(B, 2, lengthBytes(B))
            )
        requires 2 <=Int lengthBytes(B)

    rule ukmBytesDecodeInt(Value:Int, B:Bytes, T:Type)
        => ukmBytesDecode(integerToValue(Value, T), B)
    rule ukmBytesDecodeStr(Len:Int, B:Bytes)
        => ukmBytesDecode(Bytes2String(substrBytes(B, 0, Len)), substrBytes(B, Len, lengthBytes(B)))
        requires 0 <=Int Len andBool Len <=Int lengthBytes(B)

    rule ukmBytesDecode(Value:Value, B:Bytes)
        => tupleExpression(ukmBytesNew(B) , ptrValue(null, Value) , .TupleElementsNoEndComma)

    rule ukmBytesHash(ptrValue(_, u64(BytesId)))
        => ukmBytesHash(ukmBytesId(BytesId))
    rule ukmBytesHash(ukmBytesValue(B:Bytes))
        => ptrValue(null, u64(Int2MInt(#ukmBytesHash(Bytes2Int(B, BE, Unsigned)))))

    syntax Int ::= #ukmBytesHash(Int)  [function, total]
    rule #ukmBytesHash(I:Int) => #ukmBytesHash(0 -Int I)  requires I <Int 0
    rule #ukmBytesHash(I:Int) => I requires 0 <=Int I andBool I <Int (1 <<Int 64)
    rule #ukmBytesHash(I:Int)
        => #ukmBytesHash
            ( (I &Int ((1 <<Int 64) -Int 1))
            |Int #ukmBytesHash(I >>Int 64)
            )
endmodule

```

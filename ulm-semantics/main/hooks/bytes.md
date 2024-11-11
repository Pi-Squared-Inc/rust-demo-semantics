```k

module ULM-SEMANTICS-HOOKS-BYTES-CONFIGURATION
    imports INT-SYNTAX
    imports MAP

    configuration
        <ulm-bytes>
            <ulm-bytes-buffers>
                .Map  // Int to Bytes
            </ulm-bytes-buffers>
            <ulm-bytes-next-id>
                0
            </ulm-bytes-next-id>
        </ulm-bytes>
endmodule

module ULM-SEMANTICS-HOOKS-BYTES
    imports private BYTES
    imports private COMMON-K-CELL
    imports private K-EQUAL-SYNTAX
    imports private KRYPTO
    imports private RUST-HELPERS
    imports private RUST-REPRESENTATION
    imports private ULM-SEMANTICS-HOOKS-BYTES-CONFIGURATION
    imports private ULM-REPRESENTATION


    syntax Identifier ::= "bytes_hooks"  [token]
                        | "empty"  [token]
                        | "length"  [token]
                        | "equals"  [token]
                        | "append_bool"  [token]
                        | "append_bytes_raw"  [token]
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
        <ulm-bytes-buffers>
            M => M[NextId <- b""]
        </ulm-bytes-buffers>
        <ulm-bytes-next-id>
            NextId:Int => NextId +Int 1
        </ulm-bytes-next-id>
        requires notBool uoverflowMInt(64, NextId)

    rule
        normalizedFunctionCall
            ( :: bytes_hooks :: length :: .PathExprSegments
            , BufferIdId:Ptr, .PtrList
            )
        => ulmBytesLength(BufferIdId)

    rule
        normalizedFunctionCall
            ( :: bytes_hooks :: equals :: .PathExprSegments
            , BufferIdId1:Ptr, BufferIdId2:Ptr, .PtrList
            )
        => ulmBytesEquals(BufferIdId1, BufferIdId2)

    rule
        normalizedFunctionCall
            ( :: bytes_hooks :: append_u256 :: .PathExprSegments
            , BufferIdId:Ptr, IntId:Ptr, .PtrList
            )
        => ulmBytesAppendInt(BufferIdId, IntId)

    rule
        normalizedFunctionCall
            ( :: bytes_hooks :: append_u160 :: .PathExprSegments
            , BufferIdId:Ptr, IntId:Ptr, .PtrList
            )
        => ulmBytesAppendInt(BufferIdId, IntId)

    rule
        normalizedFunctionCall
            ( :: bytes_hooks :: append_u128 :: .PathExprSegments
            , BufferIdId:Ptr, IntId:Ptr, .PtrList
            )
        => ulmBytesAppendInt(BufferIdId, IntId)

    rule
        normalizedFunctionCall
            ( :: bytes_hooks :: append_u64 :: .PathExprSegments
            , BufferIdId:Ptr, IntId:Ptr, .PtrList
            )
        => ulmBytesAppendInt(BufferIdId, IntId)

    rule
        normalizedFunctionCall
            ( :: bytes_hooks :: append_u32 :: .PathExprSegments
            , BufferIdId:Ptr, IntId:Ptr, .PtrList
            )
        => ulmBytesAppendInt(BufferIdId, IntId)

    rule
        normalizedFunctionCall
            ( :: bytes_hooks :: append_u16 :: .PathExprSegments
            , BufferIdId:Ptr, IntId:Ptr, .PtrList
            )
        => ulmBytesAppendInt(BufferIdId, IntId)

    rule
        normalizedFunctionCall
            ( :: bytes_hooks :: append_u8 :: .PathExprSegments
            , BufferIdId:Ptr, IntId:Ptr, .PtrList
            )
        => ulmBytesAppendInt(BufferIdId, IntId)

    rule
        normalizedFunctionCall
            ( :: bytes_hooks :: append_bool :: .PathExprSegments
            , BufferIdId:Ptr, IntId:Ptr, .PtrList
            )
        => ulmBytesAppendBool(BufferIdId, IntId)

    rule
        normalizedFunctionCall
            ( :: bytes_hooks :: append_str :: .PathExprSegments
            , BufferIdId:Ptr, StrId:Ptr, .PtrList
            )
        => ulmBytesAppendStr(BufferIdId, StrId)

    rule
        normalizedFunctionCall
            ( :: bytes_hooks :: append_bytes_raw :: .PathExprSegments
            , BufferIdId:Ptr, ToAppendId:Ptr, .PtrList
            )
        => ulmBytesAppendBytesRaw(BufferIdId, ToAppendId)

    rule
        normalizedFunctionCall
            ( :: bytes_hooks :: decode_u256 :: .PathExprSegments
            , BufferIdId:Ptr, .PtrList
            )
        => ulmBytesDecode(BufferIdId, u256)

    rule
        normalizedFunctionCall
            ( :: bytes_hooks :: decode_u160 :: .PathExprSegments
            , BufferIdId:Ptr, .PtrList
            )
        => ulmBytesDecode(BufferIdId, u160)

    rule
        normalizedFunctionCall
            ( :: bytes_hooks :: decode_u128 :: .PathExprSegments
            , BufferIdId:Ptr, .PtrList
            )
        => ulmBytesDecode(BufferIdId, u128)

    rule
        normalizedFunctionCall
            ( :: bytes_hooks :: decode_u64 :: .PathExprSegments
            , BufferIdId:Ptr, .PtrList
            )
        => ulmBytesDecode(BufferIdId, u64)

    rule
        normalizedFunctionCall
            ( :: bytes_hooks :: decode_u32 :: .PathExprSegments
            , BufferIdId:Ptr, .PtrList
            )
        => ulmBytesDecode(BufferIdId, u32)

    rule
        normalizedFunctionCall
            ( :: bytes_hooks :: decode_u16 :: .PathExprSegments
            , BufferIdId:Ptr, .PtrList
            )
        => ulmBytesDecode(BufferIdId, u16)

    rule
        normalizedFunctionCall
            ( :: bytes_hooks :: decode_u8 :: .PathExprSegments
            , BufferIdId:Ptr, .PtrList
            )
        => ulmBytesDecode(BufferIdId, u8)

    rule
        normalizedFunctionCall
            ( :: bytes_hooks :: decode_str :: .PathExprSegments
            , BufferIdId:Ptr, .PtrList
            )
        => ulmBytesDecode(BufferIdId, str)

     rule
        normalizedFunctionCall
            ( :: bytes_hooks :: hash :: .PathExprSegments
            , BufferIdId:Ptr, .PtrList
            )
        => ulmBytesHash(BufferIdId)

    rule
        normalizedFunctionCall
            ( :: bytes_hooks :: decode_signature :: .PathExprSegments
            , BufferIdId:Ptr, .PtrList
            )
        => ulmBytesDecodeBytes(BufferIdId, 4)
    // ---------------------------------------

    rule
        <k>
            ulmBytesId(BytesId) => ulmBytesValue(Value)
            ...
        </k>
        <ulm-bytes-buffers>
            MInt2Unsigned(BytesId) |-> Value:Bytes
            ...
        </ulm-bytes-buffers>

    syntax ULMInstruction ::= ulmBytesLength(Expression)  [strict(1)]
                            | ulmBytesLength(UlmExpression)  [strict(1)]
                            | ulmBytesEquals(Expression, Expression)  [seqstrict]
                            | ulmBytesEquals(UlmExpression, UlmExpression)  [seqstrict]
                            | ulmBytesAppendInt(Expression, Expression)  [seqstrict]
                            | ulmBytesAppendInt(UlmExpression, Int)  [strict(1)]
                            | ulmBytesAppendBool(Expression, Expression)  [seqstrict]
                            | ulmBytesAppendBytesRaw(Expression, Expression)  [seqstrict]
                            | ulmBytesAppendBytesRaw(UlmExpression, UlmExpression)  [seqstrict]
                            | ulmBytesAppendStr(Expression, Expression)  [seqstrict]
                            | ulmBytesAppendBytes(UlmExpression, Bytes)  [strict(1)]
                            | ulmBytesAppendLenAndBytes(UlmExpression, Bytes)  [strict(1)]
                            | ulmBytesDecode(Expression, Type)  [strict(1)]
                            | ulmBytesDecode(UlmExpression, Type)  [strict(1)]
                            | ulmBytesDecodeBytes(Expression, Int)  [strict(1)]
                            | ulmBytesDecodeBytes(UlmExpression, Int)  [strict(1)]
                            | ulmBytesDecode(Int, Bytes, Type)
                            | ulmBytesDecodeInt(Int, Bytes, Type)
                            | ulmBytesDecodeStr(Int, Bytes)
                            | ulmBytesDecode(ValueOrError, Bytes)
                            | ulmBytesHash(Expression)  [strict(1)]
                            | ulmBytesHash(UlmExpression)  [strict(1)]

    rule
        <k>
            ulmBytesNew(B:Bytes)
            => ptrValue(null, u64(Int2MInt(NextId)))
            ...
        </k>
        <ulm-bytes-buffers>
            M => M[NextId <- B]
        </ulm-bytes-buffers>
        <ulm-bytes-next-id>
            NextId:Int => NextId +Int 1
        </ulm-bytes-next-id>
        requires notBool uoverflowMInt(64, NextId)

    rule ulmBytesLength(ptrValue(_, u64(BytesId))) => ulmBytesLength(ulmBytesId(BytesId))
    rule ulmBytesLength(ulmBytesValue(Value:Bytes))
        => ptrValue(null, u32(Int2MInt(lengthBytes(Value))))
        requires notBool uoverflowMInt(32, lengthBytes(Value))

    rule ulmBytesEquals(ptrValue(_, u64(BytesId1)), ptrValue(_, u64(BytesId2)))
        => ulmBytesEquals(ulmBytesId(BytesId1), ulmBytesId(BytesId2))
    rule ulmBytesEquals(ulmBytesValue(Value1:Bytes), ulmBytesValue(Value2:Bytes))
        => ptrValue(null, Value1 ==K Value2)

    rule ulmBytesAppendInt(ptrValue(_, u64(BytesId)), ptrValue(_, u256(Value)))
        => ulmBytesAppendInt(ulmBytesId(BytesId), MInt2Unsigned(Value))
    rule ulmBytesAppendInt(ptrValue(_, u64(BytesId)), ptrValue(_, u160(Value)))
        => ulmBytesAppendInt(ulmBytesId(BytesId), MInt2Unsigned(Value))
    rule ulmBytesAppendInt(ptrValue(_, u64(BytesId)), ptrValue(_, u128(Value)))
        => ulmBytesAppendInt(ulmBytesId(BytesId), MInt2Unsigned(Value))
    rule ulmBytesAppendInt(ptrValue(_, u64(BytesId)), ptrValue(_, u64(Value)))
        => ulmBytesAppendInt(ulmBytesId(BytesId), MInt2Unsigned(Value))
    rule ulmBytesAppendInt(ptrValue(_, u64(BytesId)), ptrValue(_, u32(Value)))
        => ulmBytesAppendInt(ulmBytesId(BytesId), MInt2Unsigned(Value))
    rule ulmBytesAppendInt(ptrValue(_, u64(BytesId)), ptrValue(_, u16(Value)))
        => ulmBytesAppendInt(ulmBytesId(BytesId), MInt2Unsigned(Value))
    rule ulmBytesAppendInt(ptrValue(_, u64(BytesId)), ptrValue(_, u8(Value)))
        => ulmBytesAppendInt(ulmBytesId(BytesId), MInt2Unsigned(Value))

    rule ulmBytesAppendInt(ulmBytesValue(B:Bytes), Value:Int)
        => ulmBytesNew(B +Bytes Int2Bytes(32, Value, BE))

    rule ulmBytesAppendBool(ptrValue(P, u64(BytesId)), ptrValue(_, false))
        => ulmBytesAppendInt(ptrValue(P, u64(BytesId)), ptrValue(null, u8(0p8)))
    rule ulmBytesAppendBool(ptrValue(P, u64(BytesId)), ptrValue(_, true))
        => ulmBytesAppendInt(ptrValue(P, u64(BytesId)), ptrValue(null, u8(1p8)))

    // TODO: This can create key ambiguity for storage
    rule ulmBytesAppendStr(ptrValue(_, u64(BytesId)), ptrValue(_, Value:String))
        => ulmBytesAppendLenAndBytes(ulmBytesId(BytesId), String2Bytes(Value))

    rule ulmBytesAppendBytesRaw(ptrValue(_, u64(BytesId)), ptrValue(_, u64(ToAppendId)))
        => ulmBytesAppendBytesRaw(ulmBytesId(BytesId), ulmBytesId(ToAppendId))
    rule ulmBytesAppendBytesRaw(ulmBytesValue(B:Bytes), ulmBytesValue(ToAppend))
        => ulmBytesNew(B +Bytes ToAppend)

    rule ulmBytesAppendBytes(ulmBytesValue(B:Bytes), Value:Bytes)
        => ulmBytesNew(B +Bytes Value)

    rule ulmBytesAppendLenAndBytes(ulmBytesValue(First:Bytes), Second:Bytes)
        => ulmBytesNew
            ( First
                +Bytes Int2Bytes(32, lengthBytes(Second), BE)
                +Bytes padRightBytes
                    ( Second
                    , ((lengthBytes(Second) +Int 31) /Int 32) *Int 32
                    , 0
                    )
            )
        requires lengthBytes(Second) <Int (1 <<Int 16)

    rule ulmBytesDecodeBytes(ptrValue(_, u64(BytesId)), L:Int)
        => ulmBytesDecodeBytes(ulmBytesId(BytesId), L:Int)
    rule ulmBytesDecodeBytes(ulmBytesValue(B:Bytes), L:Int) 
        => tupleExpression
            ( ulmBytesNew(substrBytes(B, L, lengthBytes(B)))
            , ulmBytesNew(substrBytes(B, 0, L))
            , .TupleElementsNoEndComma
            )
        requires L <=Int lengthBytes(B)

    rule ulmBytesDecode(ptrValue(_, u64(BytesId)), T:Type)
        => ulmBytesDecode(ulmBytesId(BytesId), T:Type)
    rule ulmBytesDecode(ulmBytesValue(B:Bytes), T:Type)
        => ulmBytesDecode
            ( integerToValue(Bytes2Int(substrBytes(B, 0, 32), BE, Unsigned), T)
            , substrBytes(B, 32, lengthBytes(B))
            )
        requires isUnsignedInt(T) andBool 32 <=Int lengthBytes(B)
    rule ulmBytesDecode(ulmBytesValue(B:Bytes), T:Type)
        => ulmBytesDecode
            ( integerToValue(Bytes2Int(substrBytes(B, 0, 32), BE, Signed), T)
            , substrBytes(B, 32, lengthBytes(B))
            )
        requires isSignedInt(T) andBool 32 <=Int lengthBytes(B)
    rule ulmBytesDecode(ulmBytesValue(B:Bytes), str)
        => ulmBytesDecodeStr
            ( Bytes2Int(substrBytes(B, 0, 32), BE, Signed)
            , substrBytes(B, 32, lengthBytes(B))
            )
        requires 2 <=Int lengthBytes(B)

    rule ulmBytesDecodeInt(Value:Int, B:Bytes, T:Type)
        => ulmBytesDecode(integerToValue(Value, T), B)
    rule ulmBytesDecodeStr(Len:Int, B:Bytes)
        => ulmBytesDecode
            ( Bytes2String(substrBytes(B, 0, Len))
            , substrBytes(B, ((Len +Int 31) /Int 32) *Int 32, lengthBytes(B))
            )
        requires 0 <=Int Len andBool Len <=Int lengthBytes(B)

    rule ulmBytesDecode(Value:Value, B:Bytes)
        => tupleExpression(ulmBytesNew(B) , ptrValue(null, Value) , .TupleElementsNoEndComma)

    rule ulmBytesHash(ptrValue(_, u64(BytesId)))
        => ulmBytesHash(ulmBytesId(BytesId))
    rule ulmBytesHash(ulmBytesValue(B:Bytes))
        => ptrValue(null, u256(Int2MInt(Bytes2Int(Keccak256raw(B), BE, Unsigned))))
endmodule

```

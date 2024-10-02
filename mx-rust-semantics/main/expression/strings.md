```k

module MX-RUST-EXPRESSION-STRINGS
    imports private BOOL
    imports private INT
    imports private MX-RUST-REPRESENTATION
    imports private RUST-VALUE-SYNTAX
    imports private STRING

    rule concatString(ptrValue(_, S1:String), ptrValue(_, S2:String))
          => ptrValue(null, S1 +String S2)

    rule toString(ptrValue(_, i8(Value:MInt{8})))
        => ptrValue(null, padLeftString(Base2String(MInt2Unsigned(Value), 16), "0", 8 divInt 4))
    rule toString(ptrValue(_, u8(Value:MInt{8})))
        => ptrValue(null, padLeftString(Base2String(MInt2Unsigned(Value), 16), "0", 8 divInt 4))
    rule toString(ptrValue(_, i16(Value:MInt{16})))
        => ptrValue(null, padLeftString(Base2String(MInt2Unsigned(Value), 16), "0", 16 divInt 4))
    rule toString(ptrValue(_, u16(Value:MInt{16})))
        => ptrValue(null, padLeftString(Base2String(MInt2Unsigned(Value), 16), "0", 16 divInt 4))
    rule toString(ptrValue(_, i32(Value:MInt{32})))
        => ptrValue(null, padLeftString(Base2String(MInt2Unsigned(Value), 16), "0", 32 divInt 4))
    rule toString(ptrValue(_, u32(Value:MInt{32})))
        => ptrValue(null, padLeftString(Base2String(MInt2Unsigned(Value), 16), "0", 32 divInt 4))
    rule toString(ptrValue(_, i64(Value:MInt{64})))
        => ptrValue(null, padLeftString(Base2String(MInt2Unsigned(Value), 16), "0", 64 divInt 4))
    rule toString(ptrValue(_, u64(Value:MInt{64})))
        => ptrValue(null, padLeftString(Base2String(MInt2Unsigned(Value), 16), "0", 64 divInt 4))
    rule toString(ptrValue(_, u128(Value:MInt{128})))
        => ptrValue(null, padLeftString(Base2String(MInt2Unsigned(Value), 16), "0", 128 divInt 4))
    rule toString(ptrValue(_, Value:String)) => ptrValue(null, Value)
    // TODO: convert all Value entries to string

    syntax String ::= padLeftString(value:String, padding:String, count:Int)  [function, total]
    rule padLeftString(...value:S, padding:P, count:C) => S
        requires C <=Int lengthString(S) orBool lengthString(P) =/=Int 1
    rule padLeftString(S:String => P +String S, P:String, _Count:Int)
        [owise]

endmodule

```

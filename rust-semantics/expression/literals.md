```k
module RUST-EXPRESSION-LITERALS
    imports private RUST-EXPRESSION-INTEGER-LITERALS
endmodule

module RUST-EXPRESSION-INTEGER-LITERALS
    imports private BOOL
    imports private INT
    imports private K-EQUAL-SYNTAX
    imports private STRING
    imports private RUST-ERROR-SYNTAX
    imports private RUST-REPRESENTATION
    imports private RUST-SHARED-SYNTAX

    // https://doc.rust-lang.org/stable/reference/expressions/literal-expr.html#integer-literal-expressions
    // https://doc.rust-lang.org/stable/reference/tokens.html#number-literals

    syntax String ::= IntegerLiteralToString(IntegerLiteral)  [function, total, hook(STRING.token2string)]

    rule I:IntegerLiteral => wrapPtrValueOrError(null, parseInteger(I))
    rule B:Bool:LiteralExpression => ptrValue(null, B:Bool:Value)
    rule S:String => ptrValue(null, S)

    syntax ValueOrError ::= parseInteger(IntegerLiteral)  [function, total]
                          | parseInteger(String)  [function, total]
    rule parseInteger(I:IntegerLiteral) => parseInteger(IntegerLiteralToString(I))
    rule parseInteger(I:String) => parseIntegerNormalized(replaceAll(I, "_", ""))

    syntax ValueOrError ::= parseIntegerNormalized(String)  [function, total]
    rule parseIntegerNormalized(I:String) => error("Literal not handled", I)
        requires startsWith(I, "0b") orBool startsWith(I, "0o")
    rule parseIntegerNormalized(I:String)
        => parseIntegerHexadecimalSplit(substrString(I, 2, lengthString(I)), findSuffix(I))
        requires startsWith(I, "0x")
    rule parseIntegerNormalized(I:String) => parseIntegerDecimalSplit(I, findSuffix(I))  [owise]

    syntax IntegerSuffix ::= findSuffix(String)  [function, total]
    rule findSuffix(S) => suffix(i8, 2) requires endsWith(S, "i8")
    rule findSuffix(S) => suffix(u8, 2) requires endsWith(S, "u8")
    rule findSuffix(S) => suffix(i16, 3) requires endsWith(S, "i16")
    rule findSuffix(S) => suffix(u16, 3) requires endsWith(S, "u16")
    rule findSuffix(S) => suffix(i32, 3) requires endsWith(S, "i32")
    rule findSuffix(S) => suffix(u32, 3) requires endsWith(S, "u32")
    rule findSuffix(S) => suffix(i64, 3) requires endsWith(S, "i64")
    rule findSuffix(S) => suffix(u64, 3) requires endsWith(S, "u64")
    rule findSuffix(S) => suffix(u128, 4) requires endsWith(S, "u128")
    rule findSuffix(S) => suffix(u160, 4) requires endsWith(S, "u160")
    rule findSuffix(S) => suffix(u256, 4) requires endsWith(S, "u256")
    rule findSuffix(_) => suffix(( ), 0)  [owise]

    syntax IntegerSuffix ::= suffix(Type, Int)
    syntax ValueOrError ::= parseIntegerDecimalSplit(String, IntegerSuffix)  [function, total]
    rule parseIntegerDecimalSplit(I:String, suffix(T:Type, Length))
        => parseIntegerDecimal(substrString(I, 0, lengthString(I) -Int Length), T)
        requires Length <=Int lengthString(I)
    rule parseIntegerDecimalSplit(S:String, IS:IntegerSuffix)
        => error("parseIntegerDecimalSplit", ListItem(S) ListItem(IS))
        [owise]

    syntax ValueOrError ::= parseIntegerDecimal(String,  Type)  [function, total]
    rule parseIntegerDecimal(I:String,  T:Type) => integerToValue(String2Int(I), T)
        requires isDecimal(I) andBool lengthString(I) >Int 0
    rule parseIntegerDecimal(S:String, T:Type)
        => error("parseIntegerDecimal: Unrecognized integer", ListItem(S) ListItem(T))

    syntax Bool ::= isDecimalDigit(String)  [function, total]
    rule isDecimalDigit(S) => "0" <=String S andBool S <=String "9"

    syntax Bool ::= isDecimal(String)  [function, total]
    rule isDecimal("") => true
    rule isDecimal(S:String) => isDecimalDigit(substrString(S, 0:Int, 1:Int)) andBool isDecimal(substrString(S, 1, lengthString(S)))
        [owise]


    syntax ValueOrError ::= parseIntegerHexadecimalSplit(String, IntegerSuffix)  [function, total]
    rule parseIntegerHexadecimalSplit(I:String, suffix(T:Type, Length))
        => parseIntegerHexadecimal(substrString(I, 0, lengthString(I) -Int Length), T)
        requires Length <=Int lengthString(I)
    rule parseIntegerHexadecimalSplit(S:String, IS:IntegerSuffix)
        => error("parseIntegerHexadecimalSplit", ListItem(S) ListItem(IS))
        [owise]

    syntax ValueOrError ::= parseIntegerHexadecimal(String,  Type)  [function, total]
    rule parseIntegerHexadecimal(I:String,  T:Type) => integerToValue(String2Base(I, 16), T)
        requires isHexadecimal(I) andBool lengthString(I) >Int 0
    rule parseIntegerHexadecimal(S:String, T:Type)
        => error("parseIntegerHexadecimal: Unrecognized integer", ListItem(S) ListItem(T))

    syntax Bool ::= isHexadecimalDigit(String)  [function, total]
    rule isHexadecimalDigit(S)
        => isDecimalDigit(S)
            orBool ("a" <=String S andBool S <=String "f")
            orBool ("A" <=String S andBool S <=String "F")

    syntax Bool ::= isHexadecimal(String)  [function, total]
    rule isHexadecimal("") => true
    rule isHexadecimal(S:String)
        => isHexadecimalDigit(substrString(S, 0:Int, 1:Int))
            andBool isHexadecimal(substrString(S, 1, lengthString(S)))
        [owise]

    rule integerToValue(I:Int, i8) => i8(Int2MInt(I))
        requires sminMInt(8) <=Int I andBool I <=Int smaxMInt(8)
    rule integerToValue(I:Int, u8) => u8(Int2MInt(I))
        requires uminMInt(8) <=Int I andBool I <=Int umaxMInt(8)
    rule integerToValue(I:Int, i16) => i16(Int2MInt(I))
        requires sminMInt(16) <=Int I andBool I <=Int smaxMInt(16)
    rule integerToValue(I:Int, u16) => u16(Int2MInt(I))
        requires uminMInt(16) <=Int I andBool I <=Int umaxMInt(16)
    rule integerToValue(I:Int, i32) => i32(Int2MInt(I))
        requires sminMInt(32) <=Int I andBool I <=Int smaxMInt(32)
    rule integerToValue(I:Int, u32) => u32(Int2MInt(I))
        requires uminMInt(32) <=Int I andBool I <=Int umaxMInt(32)
    rule integerToValue(I:Int, i64) => i64(Int2MInt(I))
        requires sminMInt(64) <=Int I andBool I <=Int smaxMInt(64)
    rule integerToValue(I:Int, u64) => u64(Int2MInt(I))
        requires uminMInt(64) <=Int I andBool I <=Int umaxMInt(64)
    rule integerToValue(I:Int, u128) => u128(Int2MInt(I))
        requires uminMInt(128) <=Int I andBool I <=Int umaxMInt(128)
    rule integerToValue(I:Int, u160) => u160(Int2MInt(I))
        requires uminMInt(160) <=Int I andBool I <=Int umaxMInt(160)
    rule integerToValue(I:Int, u256) => u256(Int2MInt(I))
        requires uminMInt(256) <=Int I andBool I <=Int umaxMInt(256)
    rule integerToValue(I:Int, ( )) => u128(Int2MInt(I))
    rule integerToValue(I:Int, T:Type)
        => error("integerToValue: unimplemented", ListItem(I:Int:KItem) ListItem(T:Type:KItem))
        [owise]

    rule valueToInteger(V:Value) => error("cannot convert to integer", ListItem(V))  [owise]
    rule valueToInteger(i8(V:MInt{8})) => MInt2Signed(V)
    rule valueToInteger(u8(V:MInt{8})) => MInt2Unsigned(V)
    rule valueToInteger(i16(V:MInt{16})) => MInt2Signed(V)
    rule valueToInteger(u16(V:MInt{16})) => MInt2Unsigned(V)
    rule valueToInteger(i32(V:MInt{32})) => MInt2Signed(V)
    rule valueToInteger(u32(V:MInt{32})) => MInt2Unsigned(V)
    rule valueToInteger(i64(V:MInt{64})) => MInt2Signed(V)
    rule valueToInteger(u64(V:MInt{64})) => MInt2Unsigned(V)
    rule valueToInteger(u128(V:MInt{128})) => MInt2Unsigned(V)
    rule valueToInteger(u160(V:MInt{160})) => MInt2Unsigned(V)
    rule valueToInteger(u256(V:MInt{256})) => MInt2Unsigned(V)

    syntax Bool ::= endsWith(containing:String, contained:String)  [function, total]
    rule endsWith(Containing:String, Contained:String)
        => substrString
            ( Containing
            , lengthString(Containing) -Int lengthString(Contained)
            , lengthString(Containing)
            ) ==K Contained
        requires lengthString(Contained) <=Int lengthString(Containing)
    rule endsWith(_, _) => false [owise]

    syntax Bool ::= startsWith(containing:String, contained:String)  [function, total]
    rule startsWith(Containing:String, Contained:String)
        => substrString
            ( Containing
            , 0
            , lengthString(Contained)
            ) ==K Contained
        requires lengthString(Contained) <=Int lengthString(Containing)
    rule startsWith(_, _) => false [owise]

endmodule
```

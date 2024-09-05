```k
module RUST-EXPRESSION-LITERALS
    imports private RUST-EXPRESSION-INTEGER-LITERALS
    imports private RUST-EXPRESSION-BOOLEAN-LITERALS
endmodule

module RUST-EXPRESSION-INTEGER-LITERALS
    imports BOOL
    imports INT
    imports K-EQUAL-SYNTAX
    imports STRING
    imports private RUST-REPRESENTATION
    imports RUST-SHARED-SYNTAX

    // https://doc.rust-lang.org/stable/reference/expressions/literal-expr.html#integer-literal-expressions
    // https://doc.rust-lang.org/stable/reference/tokens.html#number-literals

    syntax String ::= IntegerLiteralToString(IntegerLiteral)  [function, total, hook(STRING.token2string)]

    rule I:IntegerLiteral => parseInteger(I)

    syntax ValueOrError ::= parseInteger(IntegerLiteral)  [function, total]
                          | parseInteger(String)  [function, total]
    rule parseInteger(I:IntegerLiteral) => parseInteger(IntegerLiteralToString(I))
    rule parseInteger(I:String) => parseIntegerNormalized(replaceAll(I, "_", ""))

    syntax ValueOrError ::= parseIntegerNormalized(String)  [function, total]
    rule parseIntegerNormalized(I:String) => error("Literal not handled", I)
        requires startsWith(I, "0b") orBool startsWith(I, "0x") orBool startsWith(I, "0o")
    rule parseIntegerNormalized(I:String) => parseIntegerDecimalSplit(I, findSuffix(I))  [owise]

    syntax IntegerSuffix ::= findSuffix(String)  [function, total]
    rule findSuffix(S) => suffix(i32, 3) requires endsWith(S, "i32")
    rule findSuffix(S) => suffix(u32, 3) requires endsWith(S, "u32")
    rule findSuffix(S) => suffix(i64, 3) requires endsWith(S, "i64")
    rule findSuffix(S) => suffix(u64, 3) requires endsWith(S, "u64")
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


    syntax ValueOrError ::= integerToValue(Int, Type)  [function, total]
    rule integerToValue(I:Int, i32) => i32(Int2MInt(I))
        requires sminMInt(32) <=Int I andBool I <=Int smaxMInt(32)
    rule integerToValue(I:Int, u32) => u32(Int2MInt(I))
        requires uminMInt(32) <=Int I andBool I <=Int umaxMInt(32)
    rule integerToValue(I:Int, i64) => i64(Int2MInt(I))
        requires sminMInt(64) <=Int I andBool I <=Int smaxMInt(64)
    rule integerToValue(I:Int, u64) => u64(Int2MInt(I))
        requires uminMInt(64) <=Int I andBool I <=Int umaxMInt(64)
    rule integerToValue(I:Int, ( )) => u128(Int2MInt(I))
    rule integerToValue(I:Int, T:Type)
        => error("integerToValue: unimplemented", ListItem(I:Int:KItem) ListItem(T:Type:KItem))
        [owise]

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

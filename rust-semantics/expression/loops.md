```k

module RUST-LOOP-EXPRESSIONS
    imports K-EQUAL-SYNTAX
    imports RUST-REPRESENTATION

    syntax IteratorLoopExpression ::=  "for1" Pattern "limit" PtrValue BlockExpression
                                    | "for2" Pattern "limit" PtrValue BlockExpression

    rule for Patt:Identifier:PatternNoTopAlt | R:PatternNoTopAlts in ptrValue(_, intRange(First, Last)) B:BlockExpression =>
            {
                .InnerAttributes
                let Patt = ptrValue(null, First);
                (for1 Patt | R limit ptrValue(null, Last) B):IteratorLoopExpression;
                .NonEmptyStatements
            };
        requires checkIntOfSameType(First, Last)

    rule for1 Patt:Identifier:PatternNoTopAlt | .PatternNoTopAlts limit Last B:BlockExpression =>
        if (Patt :: .PathExprSegments):PathExprSegments < Last
        {
            .InnerAttributes B;
            (for2 Patt | .PatternNoTopAlts limit Last B):IteratorLoopExpression;
            .NonEmptyStatements
        };

    rule for2 Patt:Identifier:PatternNoTopAlt | .PatternNoTopAlts limit ptrValue(_, LastValue) #as Last B:BlockExpression =>
            incrementPatt(Patt, LastValue) ~> for1 Patt:Identifier:PatternNoTopAlt | .PatternNoTopAlts limit Last B

    rule while (E:ExpressionExceptStructExpression) S:BlockExpression => if E { .InnerAttributes S; while(E)S; .NonEmptyStatements};

    // Necessary for handling all possible integer types provided in the range expression of for loops
    syntax LetStatement ::= incrementPatt(Identifier, Value) [function]

    rule incrementPatt(Patt:Identifier, ComparisonValue:Value) =>
            let Patt = (Patt :: .PathExprSegments):PathExprSegments + ptrValue(null, oneOfSameType(ComparisonValue));
        requires oneOfSameType(ComparisonValue) =/=K tuple(.ValueList)

    syntax Value ::= oneOfSameType(Value)  [function, total]
    rule oneOfSameType(_) => tuple(.ValueList)  [owise]
    rule oneOfSameType(u8  (_)) => u8  (Int2MInt(1))
    rule oneOfSameType(i8  (_)) => i8  (Int2MInt(1))
    rule oneOfSameType(u16 (_)) => u16 (Int2MInt(1))
    rule oneOfSameType(i16 (_)) => i16 (Int2MInt(1))
    rule oneOfSameType(u32 (_)) => u32 (Int2MInt(1))
    rule oneOfSameType(i32 (_)) => i32 (Int2MInt(1))
    rule oneOfSameType(u64 (_)) => u64 (Int2MInt(1))
    rule oneOfSameType(i64 (_)) => i64 (Int2MInt(1))
    rule oneOfSameType(u128(_)) => u128(Int2MInt(1))
    rule oneOfSameType(u160(_)) => u160(Int2MInt(1))
    rule oneOfSameType(u256(_)) => u256(Int2MInt(1))

endmodule

```
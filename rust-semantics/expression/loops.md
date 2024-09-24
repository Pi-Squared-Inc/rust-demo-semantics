```k

module RUST-LOOP-EXPRESSIONS
    imports RUST-REPRESENTATION

    syntax IteratorLoopExpression ::=  "for1" Pattern "in" ExpressionExceptStructExpression BlockExpression
                                    | "for2" Pattern "in" ExpressionExceptStructExpression BlockExpression

    rule for Patt:Identifier:PatternNoTopAlt | R:PatternNoTopAlts in ptrValue(_, intRange(First, Last)) B:BlockExpression => 
            {
                .InnerAttributes
                let Patt = First;
                (for1 Patt:Identifier:PatternNoTopAlt | R:PatternNoTopAlts in First..Last B:BlockExpression):IteratorLoopExpression; 
                .NonEmptyStatements
            };
        requires checkIntOfSameType(First, Last)

    rule for1 Patt:Identifier:PatternNoTopAlt | .PatternNoTopAlts in First..Last B:BlockExpression => 
                if (Patt :: .PathExprSegments):PathExprSegments < Last { .InnerAttributes B; (for2 Patt:Identifier:PatternNoTopAlt | .PatternNoTopAlts in First..Last B):IteratorLoopExpression;  .NonEmptyStatements};
            

    rule for2 Patt:Identifier:PatternNoTopAlt | .PatternNoTopAlts in _..Last B:BlockExpression => 
            incrementPatt(Patt, Last)
            ~> for1 Patt:Identifier:PatternNoTopAlt | .PatternNoTopAlts in (Patt :: .PathExprSegments):PathExprSegments..Last B

    rule while (E:ExpressionExceptStructExpression) S:BlockExpression => if E { .InnerAttributes S; while(E)S; .NonEmptyStatements};


    // Necessary for handling all possible integer types provided in the range expression of for loops
    syntax LetStatement ::= incrementPatt(Identifier, PtrValue) [function]

    rule incrementPatt(Patt:Identifier, ComparisonValue:PtrValue) => 
            let Patt = (Patt :: .PathExprSegments):PathExprSegments + ptrValue(null, i32(Int2MInt(1:Int)));
        requires checkIntOfSameType(ComparisonValue, ptrValue(null, i32(Int2MInt(1:Int))))
    rule incrementPatt(Patt:Identifier, ComparisonValue:PtrValue) => 
            let Patt = (Patt :: .PathExprSegments):PathExprSegments + ptrValue(null, u32(Int2MInt(1:Int)));
        requires checkIntOfSameType(ComparisonValue, ptrValue(null, u32(Int2MInt(1:Int))))
    rule incrementPatt(Patt:Identifier, ComparisonValue:PtrValue) => 
            let Patt = (Patt :: .PathExprSegments):PathExprSegments + ptrValue(null, u64(Int2MInt(1:Int)));
        requires checkIntOfSameType(ComparisonValue, ptrValue(null, u64(Int2MInt(1:Int))))
    rule incrementPatt(Patt:Identifier, ComparisonValue:PtrValue) => 
            let Patt = (Patt :: .PathExprSegments):PathExprSegments + ptrValue(null, i64(Int2MInt(1:Int)));
        requires checkIntOfSameType(ComparisonValue, ptrValue(null, i64(Int2MInt(1:Int))))
    rule incrementPatt(Patt:Identifier, ComparisonValue:PtrValue) => 
            let Patt = (Patt :: .PathExprSegments):PathExprSegments + ptrValue(null, u128(Int2MInt(1:Int)));
        requires checkIntOfSameType(ComparisonValue, ptrValue(null, u128(Int2MInt(1:Int))))


endmodule

```
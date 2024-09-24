```k

module RUST-LOOP-EXPRESSIONS
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
                if (Patt :: .PathExprSegments):PathExprSegments < Last { .InnerAttributes B; (for2 Patt:Identifier:PatternNoTopAlt | .PatternNoTopAlts limit Last B):IteratorLoopExpression;  .NonEmptyStatements};
            
    rule for2 Patt:Identifier:PatternNoTopAlt | .PatternNoTopAlts limit ptrValue(_, LastValue) #as Last B:BlockExpression => 
            incrementPatt(Patt, LastValue)
            ~> for1 Patt:Identifier:PatternNoTopAlt | .PatternNoTopAlts limit Last B

    rule while (E:ExpressionExceptStructExpression) S:BlockExpression => if E { .InnerAttributes S; while(E)S; .NonEmptyStatements};


    // Necessary for handling all possible integer types provided in the range expression of for loops
    syntax LetStatement ::= incrementPatt(Identifier, Value) [function]

    rule incrementPatt(Patt:Identifier, ComparisonValue:Value) => 
            let Patt = (Patt :: .PathExprSegments):PathExprSegments + ptrValue(null, i32(Int2MInt(1:Int)));
        requires checkIntOfType(ComparisonValue, i32)
    rule incrementPatt(Patt:Identifier, ComparisonValue:Value) => 
            let Patt = (Patt :: .PathExprSegments):PathExprSegments + ptrValue(null, u32(Int2MInt(1:Int)));
        requires checkIntOfType(ComparisonValue, u32)
    rule incrementPatt(Patt:Identifier, ComparisonValue:Value) => 
            let Patt = (Patt :: .PathExprSegments):PathExprSegments + ptrValue(null, u64(Int2MInt(1:Int)));
        requires checkIntOfType(ComparisonValue, u64)
    rule incrementPatt(Patt:Identifier, ComparisonValue:Value) => 
            let Patt = (Patt :: .PathExprSegments):PathExprSegments + ptrValue(null, i64(Int2MInt(1:Int)));
        requires checkIntOfType(ComparisonValue, i64)
    rule incrementPatt(Patt:Identifier, ComparisonValue:Value) => 
            let Patt = (Patt :: .PathExprSegments):PathExprSegments + ptrValue(null, u128(Int2MInt(1:Int))); 
        requires checkIntOfType(ComparisonValue, u128)


endmodule

```
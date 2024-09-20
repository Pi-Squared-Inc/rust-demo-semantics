```k

module RUST-LOOP-EXPRESSIONS
    imports RUST-SHARED-SYNTAX
    imports RUST-VALUE-SYNTAX
    imports INT
    imports MINT

    syntax IteratorLoopExpression ::=  "for1" Pattern "in" ExpressionExceptStructExpression BlockExpression
                                    | "for2" Pattern "in" ExpressionExceptStructExpression BlockExpression

    rule for Patt:Identifier:PatternNoTopAlt | .PatternNoTopAlts in First..Last B:BlockExpression => for Patt | Patt | .PatternNoTopAlts in First..Last B:BlockExpression

    rule for Patt:Identifier:PatternNoTopAlt | Patt:Identifier:PatternNoTopAlt | R:PatternNoTopAlts in First..Last B:BlockExpression => 
            {
                .InnerAttributes
                (for1 Patt:Identifier:PatternNoTopAlt | R:PatternNoTopAlts in First..Last B:BlockExpression):IteratorLoopExpression; // Covers the cases of "for x | x in range" 
                .NonEmptyStatements
            };

    rule for1 Patt:Identifier:PatternNoTopAlt | .PatternNoTopAlts in First..Last B:BlockExpression => 
                let Patt = First; ~>
                if (Patt :: .PathExprSegments):PathExprSegments < Last B (for2 Patt:Identifier:PatternNoTopAlt | .PatternNoTopAlts in First..Last B):IteratorLoopExpression;

    rule for2 Patt:Identifier:PatternNoTopAlt | .PatternNoTopAlts in _..Last B:BlockExpression => 
            let Patt = (Patt :: .PathExprSegments):PathExprSegments + ptrValue(null, u64(Int2MInt(1:Int)));
            ~> for Patt:Identifier:PatternNoTopAlt | .PatternNoTopAlts in (Patt :: .PathExprSegments):PathExprSegments..Last B

    rule while (E:ExpressionExceptStructExpression) S:BlockExpression => if E S while(E)S

endmodule

```
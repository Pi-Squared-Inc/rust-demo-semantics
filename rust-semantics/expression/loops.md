```k

module RUST-LOOP-EXPRESSIONS
    imports RUST-SHARED-SYNTAX
    imports RUST-VALUE-SYNTAX
    imports INT
    imports MINT

    syntax IteratorLoopExpression ::=  "forAux" Pattern "in" ExpressionExceptStructExpression BlockExpression

    rule for Patt:Identifier:PatternNoTopAlt | .PatternNoTopAlts in First..Last B:BlockExpression => 
               let Patt = First; 
            ~> if (Patt :: .PathExprSegments):PathExprSegments < Last B (forAux Patt:Identifier:PatternNoTopAlt | .PatternNoTopAlts in First..Last B):IteratorLoopExpression

    rule forAux Patt:Identifier:PatternNoTopAlt | .PatternNoTopAlts in First..Last B:BlockExpression => 
            let Patt = (Patt :: .PathExprSegments):PathExprSegments + ptrValue(null, u64(Int2MInt(1:Int)));
            ~> for Patt:Identifier:PatternNoTopAlt | .PatternNoTopAlts in (Patt :: .PathExprSegments):PathExprSegments..Last B
    

    rule while (E:ExpressionExceptStructExpression) S:BlockExpression => if E S while(E)S

endmodule

```
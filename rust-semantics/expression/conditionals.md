```k

module RUST-CONDITIONAL-EXPRESSIONS
    imports RUST-SHARED-SYNTAX
    imports RUST-VALUE-SYNTAX

    rule (if ptrValue(_, true) S:BlockExpression):ExpressionWithBlock => S [owise]
    rule (if ptrValue(_, false) _:BlockExpression):ExpressionWithBlock => .K [owise]

    rule (if ptrValue(_, true) A:BlockExpression else _:IfElseExpression):ExpressionWithBlock => A
    rule (if ptrValue(_, false) _:BlockExpression else B:IfElseExpression):ExpressionWithBlock => B

    rule (if ptrValue(_, true) S:BlockExpression I:IteratorLoopExpression):ExpressionWithBlock  => S ~> I 
    rule (if ptrValue(_, false) _:BlockExpression _:IteratorLoopExpression):ExpressionWithBlock => .K 
endmodule

```
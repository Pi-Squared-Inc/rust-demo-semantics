```k

module RUST-CONDITIONALS-EVALUATION
    imports RUST-SHARED-SYNTAX
    imports RUST-VALUE-SYNTAX

    rule S:ExpressionWithBlock ; => S

    rule (if ptrValue(_, true) S:BlockExpression):ExpressionWithBlock => S [owise]
    rule (if ptrValue(_, false) _:BlockExpression):ExpressionWithBlock => . [owise]

    // rule (if ptrValue(_, false) _:BlockExpression):ExpressionWithBlock ;=> .

    rule (if ptrValue(_, true) A:BlockExpression else _:IfElseExpression):ExpressionWithBlock => A
    rule (if ptrValue(_, false) _:BlockExpression else B:IfElseExpression):ExpressionWithBlock => B

endmodule

```
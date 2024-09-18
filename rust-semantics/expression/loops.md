```k

module RUST-LOOP-EXPRESSIONS
    imports RUST-SHARED-SYNTAX
    imports RUST-VALUE-SYNTAX

    rule for I:Identifier in _:ExpressionExceptStructExpression _:BlockExpression => I
    rule while (E:ExpressionExceptStructExpression) S:BlockExpression => if E S while(E)S
endmodule

```
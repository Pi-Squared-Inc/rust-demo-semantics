```k

module RUST-EXPRESSION-TUPLE
    imports RUST-REPRESENTATION
    imports RUST-VALUE-SYNTAX

    rule ():Expression => ptrValue(null, tuple(.ValueList))
    rule (E:Expression , ):TupleExpression
        => tupleExpression(E , .TupleElementsNoEndComma)
    rule (E:Expression , T:TupleElementsNoEndComma):TupleExpression
        => tupleExpression(E , T)
    rule (E:Expression , T:TupleElementsNoEndComma,):TupleExpression
        => tupleExpression(E , T)

    syntax Instruction ::= tupleExpression(TupleElementsNoEndComma)

    rule (.K => evaluate(tupleElementsToExpressionList(Es)))
        ~> tupleExpression(Es:TupleElementsNoEndComma)
    rule (evaluate(L:ValueList) ~> tupleExpression(_:TupleElementsNoEndComma))
        => ptrValue(null, tuple(L))

    syntax ExpressionList ::= tupleElementsToExpressionList(TupleElementsNoEndComma)  [function, total]

    rule tupleElementsToExpressionList(.TupleElementsNoEndComma) => .ExpressionList
    rule tupleElementsToExpressionList(E:Expression , Es:TupleElementsNoEndComma)
        => E , tupleElementsToExpressionList(Es)
endmodule

```

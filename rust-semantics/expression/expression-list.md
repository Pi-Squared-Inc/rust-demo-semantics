```k

module RUST-EXPRESSION-EXPRESSION-LIST
    imports RUST-REPRESENTATION
    imports RUST-VALUE-SYNTAX

    rule evaluate(L:ExpressionList) => evaluate(expressionListToValueList(L))

    rule isValueWithPtr(.ExpressionList) => true
    rule isValueWithPtr(E:Expression , T:ExpressionList)
        => isValueWithPtr(E) andBool isValueWithPtr(T)

    syntax ValueListOrError ::= expressionListToValueList(ExpressionList)  [function, total]

    rule expressionListToValueList(.ExpressionList) => .ValueList
    rule expressionListToValueList(ptrValue(_, V:Value) , T:ExpressionList)
        => concat(V , expressionListToValueList(T))
    rule expressionListToValueList(E:Expression , T:ExpressionList)
        => error("Unrecognized expression (expressionListToValueList)", ListItem(E) ListItem(T))
        [owise]
endmodule

```
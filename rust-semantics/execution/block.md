```k

module RUST-BLOCK
    imports RUST-REPRESENTATION
    imports RUST-SHARED-SYNTAX
    imports RUST-STACK

    // https://doc.rust-lang.org/stable/reference/expressions/block-expr.html
    // https://doc.rust-lang.org/stable/reference/names/scopes.html

    rule {.InnerAttributes}:BlockExpression => ptrValue(null, tuple(.ValueList))
    // Pushin and popping the local state (without cleaing) should help with
    // variable shadowing
    rule {.InnerAttributes S:Statements}:BlockExpression
        => pushLocalState ~> S ~> popLocalState

    // Blocks are always value expressions and evaluate the last operand in
    // value expression context.
    rule V:PtrValue ~> popLocalState => popLocalState ~> V
endmodule

```

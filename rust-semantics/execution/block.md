```k

module RUST-BLOCK
    imports RUST-SHARED-SYNTAX
    imports RUST-STACK

    // https://doc.rust-lang.org/stable/reference/expressions/block-expr.html
    // https://doc.rust-lang.org/stable/reference/names/scopes.html

    rule {.InnerAttributes}:BlockExpression => .K
    // Pushin and popping the local state (without cleaing) should help with
    // variable shadowing
    rule {.InnerAttributes S:Statements}:BlockExpression
        => pushLocalState ~> S ~> popLocalState
endmodule

```

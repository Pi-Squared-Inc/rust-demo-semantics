```k

module RUST-STATEMENT-EXPRESSION
    imports private RUST-REPRESENTATION
    imports private RUST-SHARED-SYNTAX

    rule E:Expression ; => (E ~> clearValue)
    rule (_:PtrValue ~> clearValue) => .K
    rule clearValue => .K
endmodule

```

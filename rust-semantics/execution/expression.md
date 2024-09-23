```k

module RUST-STATEMENT-EXPRESSION
    imports private RUST-REPRESENTATION
    imports private RUST-SHARED-SYNTAX

    syntax Instruction ::= "clearValue"

    rule E:Expression ; => (E ~> clearValue)
    rule (_:PtrValue ~> clearValue) => .K
    rule clearValue => .K
endmodule

```

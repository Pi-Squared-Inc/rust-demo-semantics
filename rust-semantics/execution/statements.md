```k

module RUST-STATEMENTS
    imports RUST-SHARED-SYNTAX

    rule Nes:NonEmptyStatements E:Expression => Nes ~> E
    rule S:Statement Ss:NonEmptyStatements => S ~> Ss
    rule .NonEmptyStatements => .K
endmodule

```
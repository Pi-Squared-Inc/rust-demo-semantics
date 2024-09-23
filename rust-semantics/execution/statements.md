```k

module RUST-STATEMENTS
    imports private RUST-SHARED-SYNTAX
    imports private RUST-VALUE-SYNTAX

    syntax K ::= statementsToK(NonEmptyStatements)  [function, total]
    rule statementsToK(.NonEmptyStatements) => .K
    rule statementsToK(S:Statement Ss:NonEmptyStatements)
        => S ~> statementsToK(Ss)

    rule Nes:NonEmptyStatements E:Expression => statementsToK(Nes) ~> E
    rule Ss:NonEmptyStatements => statementsToK(Ss) ~> ptrValue(null, tuple(.ValueList))
endmodule

```
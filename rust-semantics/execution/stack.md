```k

module RUST-STACK
    imports private COMMON-K-CELL
    imports private LIST
    imports private RUST-EXECUTION-CONFIGURATION

    syntax Instruction  ::= "pushLocalState"
                          | "popLocalState"

    rule
        <k>
            pushLocalState => .K
            ...
        </k>
        <locals> Locals </locals>
        <stack> .List => ListItem(Locals) ... </stack>

    rule
        <k>
            popLocalState => .K
            ...
        </k>
        <locals> _ => Locals </locals>
        <stack> ListItem(Locals) => .List ... </stack>

endmodule

```
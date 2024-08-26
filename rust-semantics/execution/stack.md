```k

module RUST-STACK
    imports LIST
    imports RUST-RUNNING-CONFIGURATION

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
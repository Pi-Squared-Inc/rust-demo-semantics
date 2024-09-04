```k

module MX-RUST-TOOLS
    imports private COMMON-K-CELL
    imports private RUST-EXECUTION-CONFIGURATION
    imports private RUST-VALUE-SYNTAX

    rule
        <k> mxRustNewValue(V:Value) => ptrValue(ptr(NextId), V) ... </k>
        <next-value-id> NextId:Int => NextId +Int 1 </next-value-id>
        <values> Values:Map => Values[NextId <- V] </values>
endmodule

```

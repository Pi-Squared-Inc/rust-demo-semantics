```k

module RUST-EXPRESSION-STRUCT
    imports private COMMON-K-CELL
    imports private RUST-EXECUTION-CONFIGURATION
    imports private RUST-REPRESENTATION

    rule
        <k> Rust#newStruct(P:TypePath, Fields:Map) => ptrValue(ptr(NVI), struct(P, Fields)) ... </k>
        <values> VALUES:Map => VALUES[NVI <- struct(P, Fields)] </values>
        <next-value-id> NVI:Int => NVI +Int 1 </next-value-id>

endmodule

```

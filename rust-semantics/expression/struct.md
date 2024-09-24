```k

module RUST-EXPRESSION-STRUCT
    imports private COMMON-K-CELL
    imports private RUST-EXECUTION-CONFIGURATION
    imports private RUST-REPRESENTATION

    rule
        <k> Rust#newStruct(P:TypePath, Fields:Map) => ptrValue(ptr(NVI), struct(P, Fields)) ... </k>
        <values> VALUES:Map => VALUES[NVI <- struct(P, Fields)] </values>
        <next-value-id> NVI:Int => NVI +Int 1 </next-value-id>

    rule
        <k>
            ptrValue(_, struct(_, FieldName |-> FieldValueId:Int _:Map)) . FieldName:Identifier
            => ptrValue(ptr(FieldValueId), V)
            ...
        </k>
        <values> FieldValueId |-> V:Value ... </values>
endmodule

```

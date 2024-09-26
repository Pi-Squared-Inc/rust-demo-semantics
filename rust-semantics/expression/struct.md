```k

module RUST-EXPRESSION-STRUCT
    imports private COMMON-K-CELL
    imports private RUST-CONVERSIONS-SYNTAX
    imports private RUST-ERROR-SYNTAX
    imports private RUST-EXECUTION-CONFIGURATION
    imports private RUST-REPRESENTATION

    rule
        <k>
            normalizedMethodCall
                ( StructName:TypePath
                , #token("clone", "Identifier"):Identifier
                , (ptr(SelfPtr), .PtrList)
                )
            => ptrValue(ptr(NVI), struct(StructName, FieldValues))
            ...
        </k>
        <values>
            ( SelfPtr |-> struct(StructName, FieldValues:Map)
              _:Map
            ) #as Values
            => Values[NVI <- struct(StructName, FieldValues)]
        </values>
        <next-value-id> NVI:Int => NVI +Int 1 </next-value-id>

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

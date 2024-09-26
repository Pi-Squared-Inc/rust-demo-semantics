```k

module MX-RUST-GLUE
    imports private COMMON-K-CELL
    imports private K-EQUAL-SYNTAX
    imports private MX-COMMON-SYNTAX
    imports private MX-RUST-REPRESENTATION
    imports private RUST-EXECUTION-CONFIGURATION
    imports private RUST-VALUE-SYNTAX

    rule (.K => mxValueToRust(T, V))
        ~> storeHostValue
                (... destination: rustDestination(_ValueId, rustType(T):MxRustType)
                , value: V:MxValue
                )
        requires notBool isMxEmptyValue(V)
    rule
        <k>
            ptrValue(_, V:Value)
            ~> storeHostValue
                (... destination: rustDestination(ValueId, _:MxRustType)
                , value: _:MxValue
                )
            => .K
            ...
        </k>
        <values> Values:Map => Values[ValueId <- V] </values>
        requires ValueId >=Int 0

    rule
        (.K => mxRustEmptyValue(T))
        ~>  storeHostValue
                (... destination: rustDestination(_, T:MxRustType)
                , value: mxEmptyValue
                )

    rule
        <k>
            mxRustLoadPtr(P:Int) => ptrValue(ptr(P), V)
            ...
        </k>
        <values> P |-> V:Value ... </values>

    rule
        <k> mxRustNewValue(V:Value) => ptrValue(ptr(NextId), V) ... </k>
        <next-value-id> NextId:Int => NextId +Int 1 </next-value-id>
        <values> Values:Map => Values[NextId <- V] </values>

    rule V:MxValue ~> mxValueToRust(T:Type)
        => mxValueToRust(T, V)

    rule mxValueToRust(&T => T, _V)
    rule mxValueToRust(T:Type, mxIntValue(I:Int))
        => mxRustNewValue(integerToValue(I, T))
        requires
            (T ==K i32 orBool T ==K u32)
            orBool (T ==K i64 orBool T ==K u64)

    rule ptrValue(_, V) ~> rustValueToMx => rustValueToMx(V)

    rule rustValueToMx(tuple(.ValueList)) => mxUnitValue()
    rule rustValueToMx(B:Bool) => mxBoolValue(B)
    rule rustValueToMx(S:String) => mxStringValue(S)
    
    rule rustValueToMx(V:Value) => mxIntValue({valueToInteger(V)}:>Int)
        requires notBool isSemanticsError(valueToInteger(V))

    rule mxIntValue(0) ~> mxRustCheckMxStatus => .K

endmodule

```

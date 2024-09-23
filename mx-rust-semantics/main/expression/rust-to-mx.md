```k

module MX-RUST-EXPRESSION-RUST-TO-MX
    imports private COMMON-K-CELL
    imports private K-EQUAL-SYNTAX
    imports private LIST
    imports private MAP
    imports private MX-COMMON-SYNTAX
    imports private MX-RUST-REPRESENTATION-CONVERSIONS
    imports private RUST-CONVERSIONS-SYNTAX
    imports private RUST-EXECUTION-CONFIGURATION
    imports private RUST-REPRESENTATION

    rule V:MxValue ~> rustToMx => rustToMx(V)

    rule
        <k>
            rustToMx(struct (_, Fields:Map))
            => rustValuesToMxListValue
                ( ptrListToValueList(listToPtrList(values(Fields)), Values)
                , .MxValueList
                )
            ...
        </k>
        <values> Values:Map </values>
        [owise]
    rule rustToMx(S:String => mxStringValue(S))
    rule rustToMx(tuple(V:ValueList)) => rustValuesToMxListValue(V, .MxValueList)

    syntax RustMxInstruction ::= rustValuesToMxListValue(ValueListOrError, MxValueList)
    rule rustValuesToMxListValue(.ValueList, L:MxValueList)
        => rustToMx(mxListValue(reverse(L, .MxValueList)))
    rule (.K => rustToMx(HOLE)) ~> rustValuesToMxListValue(((HOLE:Value , V:ValueList) => V), _:MxValueList)
    rule (rustToMx(HOLE:MxValue) => .K) ~> rustValuesToMxListValue(_:ValueList, (L:MxValueList => (HOLE, L)))
endmodule

```

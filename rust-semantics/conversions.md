```k

module RUST-CONVERSIONS-SYNTAX
    imports LIST
    imports RUST-REPRESENTATION

    syntax PtrListOrError ::= listToPtrList(List)  [function, total]
    syntax ValueListOrError ::= ptrListToValueList(PtrListOrError, Map)  [function, total]
    syntax ValueListOrError ::= callParamsToValueList(CallParamsList)  [function, total]
endmodule

module RUST-CONVERSIONS
    imports private RUST-CONVERSIONS-SYNTAX
    imports private RUST-ERROR-SYNTAX

    rule listToPtrList(.List) => .PtrList
    rule listToPtrList(ListItem(P:Int) L:List) => concat(ptr(P), listToPtrList(L))
    rule listToPtrList(L:List) => error("Unrecognized element (listToPtrList)", L)
        [owise]

    rule ptrListToValueList(E:SemanticsError, _:Map) => E
    rule ptrListToValueList(.PtrList, _:Map) => .ValueList
    rule ptrListToValueList((ptr(P:Int) , Ps:PtrList), M:Map)
        => concat({M[P:Int:KItem]}:>Value, ptrListToValueList(Ps, M:Map))
        requires P:Int:KItem in_keys(M) andBool isValue(M[P:Int:KItem] orDefault 0)
        [preserves-definedness]
    rule ptrListToValueList(Ps:PtrList, M:Map)
        => error("element not in map or wrong value type (ptrListToValueList)", ListItem(Ps) ListItem(M))
        [owise]

    rule callParamsToValueList(.CallParamsList) => .ValueList
    rule callParamsToValueList(ptrValue(_, V:Value) , L:CallParamsList)
        => concat(V, callParamsToValueList(L))
    rule callParamsToValueList(L:CallParamsList)
        => error("callParamsToValueList: Unexpected value", ListItem(L))
        [owise]
endmodule

```

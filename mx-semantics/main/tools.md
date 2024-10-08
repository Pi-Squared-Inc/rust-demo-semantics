```k

module MX-TOOLS
    imports private BOOL
    imports private INT
    imports private MX-COMMON-SYNTAX

  // ---------------------------------------------------------------
    rule getMxString(mxStringValue(S)) => S
    rule getMxString(_) => ""  [owise]
    rule getMxUint(mxIntValue(V)) => V  requires V >=Int 0
    rule getMxUint(_) => 0  [owise]

  // -----------------------------------------------------------------------------
    rule [checkBool-t]:
        checkBool(B, _)   => .K requires B
    rule [checkBool-f]:
        checkBool(B, ERR) => #exception(ExecutionFailed, ERR) requires notBool B

  // -----------------------------------------------------------------------------
    rule lengthValueList(.MxValueList) => 0
    rule lengthValueList(_ , L:MxValueList) => 1 +Int lengthValueList(L)
    // Fix for https://github.com/runtimeverification/k/issues/4587
    rule lengthValueList(_) => 0  [owise]

    rule reverse(.MxValueList, L:MxValueList) => L
    rule reverse((E:MxValue , L1:MxValueList => L1), (L2:MxValueList => E , L2))

    rule append(.MxValueList, V:MxValue) => V , .MxValueList
    rule append(A:MxValue , L:MxValueList, V:MxValue) => A , append(L , V)

    rule setAtIndex(_:MxValue , L:MxValueList, 0, V:MxValue) => V , L
    rule setAtIndex(Vl:MxValue , L:MxValueList, Index:Int, V:MxValue)
        => Vl , setAtIndex(L, Index -Int 1, V)
        requires Index >Int 0

endmodule

```
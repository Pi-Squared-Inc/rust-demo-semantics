```k

module MX-BIGUINT-TOOLS
    imports private COMMON-K-CELL
    imports private MX-BIGUINT-CONFIGURATION
    imports private MX-COMMON-SYNTAX

    rule
        <k> mxGetBigInt(IntId:Int) => mxIntValue(V) ... </k>
        <bigIntHeap> IntId |-> V:Int ... </bigIntHeap>
endmodule

```

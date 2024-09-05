```k

module MX-BIGUINT-TOOLS
    imports private COMMON-K-CELL
    imports private MX-BIGUINT-CONFIGURATION
    imports private MX-COMMON-SYNTAX

    rule
        <k> clearBigInts => .K ... </k>
        <bigIntHeap> _ => .Map </bigIntHeap>
        <bigIntHeapNextId> _ => 0 </bigIntHeapNextId>
endmodule

```

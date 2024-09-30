```k

module MX-BUFFER-TOOLS
    imports private COMMON-K-CELL
    imports private MX-BUFFERS-CONFIGURATION
    imports private MX-COMMON-SYNTAX

    rule
        <k> mxGetBuffer(BufferId:Int) => V ... </k>
        <buffer-heap> BufferId |-> V:MxValue ... </buffer-heap>
endmodule

```

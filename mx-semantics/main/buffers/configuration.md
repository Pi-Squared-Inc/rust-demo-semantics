```k

module MX-BUFFERS-CONFIGURATION
    imports INT
    imports MAP

    configuration
        <mx-buffers>
            // TODO: Use a List-based repersentation instead of
            // MxValueList to make get and size faster.
            <buffer-heap> .Map </buffer-heap>  // Int to MxValue (mxValueList)
            <buffer-heap-next-id> 0 </buffer-heap-next-id>
        </mx-buffers>
endmodule

```

```k

module MX-STORAGE-HOOKS
    imports MX-COMMON-SYNTAX
    imports MX-STORAGE-TOOLS-SYNTAX

    rule MX#storageLoad(mxStringValue(Key:String), Destination:MxValue )
        => storageLoad(getCallee(), Key, Destination)

endmodule

```

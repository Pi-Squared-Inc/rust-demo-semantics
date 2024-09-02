```k

module MX-STORAGE-TOOLS-SYNTAX
    imports MX-COMMON-SYNTAX
    imports STRING-SYNTAX

    syntax MxInstructions ::= storageLoad(address: String, key: String, destination: MxValue)
endmodule

module MX-STORAGE-TOOLS
    imports private COMMON-K-CELL
    imports private MX-ACCOUNTS-CONFIGURATION
    imports private MX-COMMON-SYNTAX
    imports private MX-STORAGE-TOOLS-SYNTAX
    imports private STRING-SYNTAX

    rule
        <k>
            storageLoad(... address: Address:String, key: _Key:String, destination: Destination:MxValue)
            => storeHostValue(Destination, mxWrappedEmpty)
            ...
        </k>
        <mx-account-address> Address </mx-account-address>
        [priority(100)]

endmodule

```

```k

module MX-STORAGE-TOOLS-SYNTAX
    imports MX-COMMON-SYNTAX
    imports STRING-SYNTAX

    syntax MxInstructions ::= storageLoad(address: String, key: String, destination: MxValue)
                            | storageStore(address: String, key: String, value: MxWrappedValue)
endmodule

module MX-STORAGE-TOOLS
    imports private COMMON-K-CELL
    imports private MX-ACCOUNTS-CONFIGURATION
    imports private MX-COMMON-SYNTAX
    imports private MX-STORAGE-TOOLS-SYNTAX
    imports private STRING-SYNTAX

    rule
        <k>
            storageLoad(... address: Address:String, key: Key:String, destination: Destination:MxValue)
            => storeHostValue(Destination, Value)
            ...
        </k>
        <mx-account-address> Address </mx-account-address>
        <mx-account-storage-key> Key </mx-account-storage-key>
        <mx-account-storage-value> Value </mx-account-storage-value>
        [priority(50)]

    rule
        <k>
            storageLoad(... address: Address:String, key: _Key:String, destination: Destination:MxValue)
            => storeHostValue(Destination, mxWrappedEmpty)
            ...
        </k>
        <mx-account-address> Address </mx-account-address>
        [priority(100)]

    rule
        <k>
            storageStore(... address: Address:String, key: Key:String, value: Value:MxWrappedValue)
            => .K
            ...
        </k>
        <mx-account-address> Address </mx-account-address>
        <mx-account-storage-key> Key </mx-account-storage-key>
        <mx-account-storage-value> _ => Value </mx-account-storage-value>
        [priority(50)]

    rule
        <k>
            storageStore(... address: Address:String, key: Key:String, value: Value:MxWrappedValue)
            => .K
            ...
        </k>
        <mx-account-address> Address </mx-account-address>
        <mx-account-storage>
            .Bag =>
            <mx-account-storage-item>
                <mx-account-storage-key> Key </mx-account-storage-key>
                <mx-account-storage-value> Value </mx-account-storage-value>
            </mx-account-storage-item>
            ...
        </mx-account-storage>
        [priority(100)]

endmodule

```

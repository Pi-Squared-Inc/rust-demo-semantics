```k

module MX-ACCOUNTS-CONFIGURATION
    imports INT-SYNTAX
    imports STRING-SYNTAX
    imports MX-STORAGE-CONFIGURATION

    configuration
        <mx-accounts>
            <mx-account multiplicity="*" type="Map">
                // TODO: The address should be bytes.
                <mx-account-address> "" </mx-account-address>
                <mx-esdt-datas>
                    <mx-esdt-data multiplicity="*" type="Map">
                        // TODO: The esdt-id should be bytes.
                        <mx-esdt-id>
                            <mx-esdt-id-name> "" </mx-esdt-id-name>
                            <mx-esdt-id-nonce> 0 </mx-esdt-id-nonce>
                        </mx-esdt-id>
                        <mx-esdt-balance> 0 </mx-esdt-balance>
                    </mx-esdt-data>
                </mx-esdt-datas>
                <mx-account-storage/>
            </mx-account>
        </mx-accounts>

endmodule

module MX-ACCOUNTS-STACK-CONFIGURATION
    imports LIST

    configuration
        <mx-world-stack> .List </mx-world-stack>
endmodule

module MX-STORAGE-CONFIGURATION
    imports MX-COMMON-SYNTAX

    configuration
        <mx-account-storage>
            <mx-account-storage-item multiplicity="*" type="Map">
                <mx-account-storage-key> "" </mx-account-storage-key>
                <mx-account-storage-value> mxWrappedEmpty </mx-account-storage-value>
            </mx-account-storage-item>
        </mx-account-storage>
endmodule

```

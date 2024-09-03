```k

module MX-ACCOUNTS-CONFIGURATION
    imports INT-SYNTAX
    imports STRING-SYNTAX

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
            </mx-account>
        </mx-accounts>

endmodule

```

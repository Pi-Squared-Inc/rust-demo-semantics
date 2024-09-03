```k

module MX-ACCOUNTS-HOOKS
    imports private COMMON-K-CELL
    imports private MX-ACCOUNTS-CONFIGURATION
    imports private MX-COMMON-SYNTAX

    rule
        <k> MX#bigIntGetESDTExternalBalance
                ( mxStringValue(Owner:String)
                , mxStringValue(TokenId:String)
                , mxIntValue(Nonce:Int)
                , .MxValueList
                ) => MX#bigIntNew(mxIntValue(Balance)) ... </k>
        <mx-account-address> Owner </mx-account-address>
        <mx-esdt-id>
            <mx-esdt-id-name> TokenId </mx-esdt-id-name>
            <mx-esdt-id-nonce> Nonce </mx-esdt-id-nonce>
        </mx-esdt-id>
        <mx-esdt-balance> Balance:Int </mx-esdt-balance>
        [priority(50)]

    rule
        <k> MX#bigIntGetESDTExternalBalance
                ( mxStringValue(Owner:String)
                , mxStringValue(_TokenId:String)
                , mxIntValue(_Nonce:Int)
                , .MxValueList
                ) => MX#bigIntNew(mxIntValue(0)) ... </k>
        <mx-account-address> Owner </mx-account-address>
        [priority(100)]

endmodule

```
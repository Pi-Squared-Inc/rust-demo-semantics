```k

module MX-ACCOUNTS-CODE-TOOLS
    imports private COMMON-K-CELL
    imports private MX-ACCOUNTS-ADDRESS-CONFIGURATION
    imports private MX-ACCOUNTS-CODE-CONFIGURATION

    rule
        <k> newExecutionEnvironment(... contractAddress: Address:String)
            => host.newEnvironment(Code)
            ...
        </k>
        <mx-account-address> Address </mx-account-address>
        <mx-account-code> Code:ContractCode </mx-account-code>
endmodule

```

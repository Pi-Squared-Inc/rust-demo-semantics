```k

module MX-SETUP-SYNTAX
    imports MX-COMMON-SYNTAX
    imports STRING
    syntax MxInstruction  ::= "MXSetup#add_account" "(" String ")"
                            | "MXSetup#add_account_with_code" "(" String "," ContractCode ")"
endmodule

module MX-SETUP
    imports private COMMON-K-CELL
    imports private MX-ACCOUNTS-CONFIGURATION
    imports private MX-SETUP-SYNTAX

    syntax MxInstruction ::= "MXSetup#error"

    rule
        <k> (.K => MXSetup#error) ~> MXSetup#add_account(S:String)  ... </k>
        <mx-account-address> S </mx-account-address>
        [priority(50)]
    rule
        <k> MXSetup#add_account(S:String) => .K ... </k>
        <mx-accounts>
            .Bag
            =>  <mx-account>
                    <mx-account-address> S </mx-account-address>
                    // <mx-esdt-datas> .Bag </mx-esdt-datas>
                    // <mx-account-storage> .Bag </mx-account-storage>
                    ...
                </mx-account>
            ...
        </mx-accounts>
        [priority(100)]

    rule
        <k> (.K => MXSetup#error) ~> MXSetup#add_account_with_code(S:String, _)  ... </k>
        <mx-account-address> S </mx-account-address>
        [priority(50)]
    rule
        <k> MXSetup#add_account_with_code(S:String, Code:ContractCode) => .K ... </k>
        <mx-accounts>
            .Bag
            =>  <mx-account>
                    <mx-account-address> S </mx-account-address>
                    <mx-account-code> Code </mx-account-code>
                    ...
                </mx-account>
            ...
        </mx-accounts>
        [priority(100)]

endmodule

```

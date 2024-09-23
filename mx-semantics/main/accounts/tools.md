```k

module MX-ACCOUNTS-TOOLS
    imports private BOOL
    imports private COMMON-K-CELL
    imports private INT
    imports private MX-ACCOUNTS-ADDRESS-CONFIGURATION
    imports private MX-ACCOUNTS-ESDT-CONFIGURATION
    // TODO: refactor so that MX-ACCOUNTS-CONFIGURATION is not needed here.
    imports private MX-ACCOUNTS-CONFIGURATION
    // TODO: refactor so that MX-ACCOUNTS-STACK-CONFIGURATION is not needed here.
    imports private MX-ACCOUNTS-STACK-CONFIGURATION
    imports private MX-COMMON-SYNTAX
    imports private STRING

    syntax MxInstructions ::= transferESDT
                                  ( source: String
                                  , destination: String
                                  , token: String
                                  , nonce: Int
                                  , value: Int
                                  )
                            | checkAccountExists(address: String)
                            | checkESDTBalance(account: String, token: String, value: Int)
                            | modifyEsdtBalance(account: String, token: String, delta: Int, allowNew: Bool)

 // ------------------------------------------------------

    rule transferESDTs(... transfers: .MxEsdtTransferList) => .K
    rule (.K => transferESDT
                (... source: Source, destination: Destination
                , token: TokenName, nonce: Nonce, value: Value
                )
        ) ~> transferESDTs
            (... source: Source:String
            , destination: Destination:String
            , transfers:
                ( mxTransferValue
                    (... token: TokenName:String
                    , nonce: Nonce:Int
                    , value: Value:Int
                    )
                , Ts:MxEsdtTransferList
                ) => Ts
            )

    rule transferESDT
            (... source: Source:String, destination: Destination:String
            , token: TokenName:String, nonce: 0, value: Value:Int
            )
      => checkAccountExists(Source)
      ~> checkAccountExists(Destination)
      ~> checkESDTBalance(Source, TokenName, Value)
      ~> modifyEsdtBalance(Source, TokenName, 0 -Int Value, false)
      ~> modifyEsdtBalance(Destination, TokenName, Value, true)

 // ------------------------------------------------------

    rule [checkAccountExists-pass]:
        <k> checkAccountExists(Address:String) => .K ... </k>
        <mx-account-address> Address </mx-account-address>
      [priority(50)]

    rule [checkAccountExists-fail]:
        <k> checkAccountExists(Address:String)
            => #exception(ExecutionFailed, "account not found: " +String Address)
            ...
        </k>
      [priority(100)]


 // ------------------------------------------------------
    rule [checkESDTBalance]:
        <k> checkESDTBalance(Account:String, TokenName:String, Value:Int)
            => .K
            ...
        </k>
        <mx-account-address> Account </mx-account-address>
        <mx-esdt-id>
            <mx-esdt-id-name> TokenName </mx-esdt-id-name>
            <mx-esdt-id-nonce> 0 </mx-esdt-id-nonce>
        </mx-esdt-id>
        <mx-esdt-balance> OriginalFrom:Int </mx-esdt-balance>
        requires Value <=Int OriginalFrom
        [priority(50)]

    // VALUE > ORIGFROM or TOKEN does not exist
    rule [checkESDTBalance-oof-instrs-empty]:
        <k> checkESDTBalance(_, _, _) => #exception(OutOfFunds, "") ... </k>
        [priority(100)]

  // ------------------------------------------------------
    rule [modifyEsdtBalance]:
        <k>
            modifyEsdtBalance
                (... account: Account:String
                , token: TokenName:String
                , delta: Delta:Int
                , allowNew: _:Bool
                )
            => .K
            ...
        </k>
        <mx-account-address> Account </mx-account-address>
        <mx-esdt-id>
            <mx-esdt-id-name> TokenName </mx-esdt-id-name>
            <mx-esdt-id-nonce> 0 </mx-esdt-id-nonce>
        </mx-esdt-id>
        <mx-esdt-balance> OriginalFrom:Int => OriginalFrom +Int Delta </mx-esdt-balance>
        [priority(50)]

    rule [modifyEsdtBalance-new-esdtData]:
        <k>
            modifyEsdtBalance
                (... account: Account:String
                , token: TokenName:String
                , delta: Delta:Int
                , allowNew: true
                )
            => .K
            ...
        </k>
        <mx-account-address> Account </mx-account-address>
        ( .Bag =>
            <mx-esdt-data>
                <mx-esdt-id>
                    <mx-esdt-id-name> TokenName </mx-esdt-id-name>
                    <mx-esdt-id-nonce> 0 </mx-esdt-id-nonce>
                </mx-esdt-id>
                <mx-esdt-balance> Delta </mx-esdt-balance>
            </mx-esdt-data>
        )
        [priority(100), preserves-definedness]

    rule [modifyEsdtBalance-new-err-instrs-empty]:
        modifyEsdtBalance(... account: _:String, token: _:String, delta: _:Int, allowNew: false)
        => #exception(ExecutionFailed, "new ESDT data on sender")
        [priority(100), preserves-definedness]

  // ------------------------------------------------------
    rule [pushWorldState]:
         <k> pushWorldState => .K ... </k>
         <mx-world-stack> (.List => ListItem(ACCTDATA)) ... </mx-world-stack>
         <mx-accounts> ACCTDATA </mx-accounts>
    rule [dropWorldState]:
         <k> dropWorldState => .K ... </k>
         <mx-world-stack> (ListItem(_) => .List) ... </mx-world-stack>
    rule [popWorldState]:
         <k> popWorldState => .K ... </k>
         <mx-world-stack> (ListItem(ACCTDATA) => .List) ... </mx-world-stack>
         <mx-accounts> _ => ACCTDATA </mx-accounts>

  // ------------------------------------------------------
    rule transferFunds(... from: From:String, to: To:String, amount: 0)
        => checkAccountExists(From)
        ~> checkAccountExists(To)

endmodule

```

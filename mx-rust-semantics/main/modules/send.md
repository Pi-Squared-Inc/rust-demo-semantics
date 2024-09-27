```k

module MX-RUST-MODULES-SEND
    imports private COMMON-K-CELL
    imports private MX-COMMON-SYNTAX
    imports private MX-RUST-REPRESENTATION
    imports private MX-RUST-REPRESENTATION-CONVERSIONS
    imports private RUST-EXECUTION-CONFIGURATION
    imports private RUST-SHARED-SYNTAX

    syntax Identifier ::= "MxRust#Send"  [token]

    syntax MxRustStructType ::= "sendType"  [function, total]
    rule sendType
        => rustStructType
            ( MxRust#Send
            , .MxRustStructFields
            )

    rule
        normalizedMethodCall
            ( MxRust#Send
            , #token("new", "Identifier"):Identifier
            , .PtrList
            )
        =>  mxRustNewStruct
                ( sendType
                , .CallParamsList
                )

    rule
        <k>
            normalizedMethodCall
                ( MxRust#Send
                , #token("direct_esdt", "Identifier"):Identifier
                ,   ( ptr(_SelfId:Int)
                    , ptr(AddressId:Int)
                    , ptr(TokenIdId:Int)
                    , ptr(NonceId:Int)
                    , ptr(AmountId:Int)
                    , .PtrList
                    )
                )
            => rustMxDirectEsdt
                    (... destination: Address
                    , tokenId: TokenId
                    , nonce: Nonce
                    , amount: Amount
                    )
                ~> mxRustCheckMxStatus
                ~> ptrValue(null, ())
            ...
        </k>
        <values>
            AddressId |-> Address:Value
            TokenIdId |-> TokenId:Value
            NonceId |-> Nonce:Value
            AmountId |-> Amount:Value
            ...
        </values>

    syntax RustMxInstruction ::= rustMxDirectEsdt
                                    ( destination: RustToMxOrInstruction  // RustToMx
                                    , tokenId: RustToMxOrInstruction  // RustToMx
                                    , nonce: RustToMxOrInstruction  // RustToMx
                                    , amount: RustToMxOrInstruction  // RustToMx
                                    )
    context rustMxDirectEsdt
                (... destination: HOLE:RustToMx => rustToMx(HOLE)
                , tokenId: _:RustToMx
                , nonce: _:RustToMx
                , amount: _:RustToMx
                )
        [result(MxValue)]
    context rustMxDirectEsdt
                (... destination: Destination:RustToMx
                , tokenId: HOLE:RustToMx => rustToMx(HOLE)
                , nonce: _:RustToMx
                , amount: _:RustToMx
                )
        requires isMxValue(Destination)
        [result(MxValue)]
    context rustMxDirectEsdt
                (... destination: Destination:RustToMx
                , tokenId: TokenId:RustToMx
                , nonce: HOLE:RustToMx => rustToMx(HOLE)
                , amount: _:RustToMx
                )
        requires isMxValue(Destination)
            andBool isMxValue(TokenId)
        [result(MxValue)]
    context rustMxDirectEsdt
                (... destination: Destination:RustToMx
                , tokenId: TokenId:RustToMx
                , nonce: Nonce:RustToMx
                , amount: HOLE:RustToMx => rustToMx(HOLE)
                )
        requires isMxValue(Destination)
            andBool isMxValue(TokenId)
            andBool isMxValue(Nonce)
        [result(MxValue)]

    rule rustMxDirectEsdt
            (... destination: mxListValue(Destination:MxValue , .MxValueList)
            , tokenId: mxListValue(mxStringValue(TokenId:String) , .MxValueList)
            , nonce: mxIntValue(Nonce:Int)
            , amount: mxIntValue(Amount:Int)
            )
        => MX#managedMultiTransferESDTNFTExecute
            ( Destination
            , mxTransfersValue
                ( mxTransferValue(... token:TokenId, nonce:Nonce, value: Amount)
                , .MxEsdtTransferList
                )
            , mxIntValue(0)  // TODO: Use some gas value
            , mxStringValue("")
            , mxListValue(.MxValueList)
            )

endmodule

```

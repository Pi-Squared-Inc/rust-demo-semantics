```k

module MX-RUST-MODULES-CALL-VALUE
    imports private COMMON-K-CELL
    imports private MX-COMMON-SYNTAX
    imports private MX-RUST-REPRESENTATION
    imports private MX-RUST-REPRESENTATION-CONVERSIONS
    imports private RUST-EXECUTION-CONFIGURATION
    imports private RUST-SHARED-SYNTAX

    syntax Identifier ::= "MxRust#CallValue"  [token]

    syntax MxRustStructType ::= "callValueType"  [function, total]
    rule callValueType
        => rustStructType
            ( MxRust#CallValue
            , .MxRustStructFields
            )

    rule
        normalizedMethodCall
            ( MxRust#CallValue
            , #token("new", "Identifier"):Identifier
            , .PtrList
            )
        =>  mxRustNewStruct
                ( callValueType
                , .CallParamsList
                )

    rule
        normalizedMethodCall
            ( MxRust#CallValue
            , #token("single_fungible_esdt", "Identifier"):Identifier
            ,   ( ptr(_SelfId:Int)
                , .PtrList
                )
            )
        => MX#managedGetMultiESDTCallValue(.MxValueList)
            ~> getSingleEsdt
            ~> mxToRustTyped((str, #token("BigUint", "Identifier")))

    syntax MxRustInstruction ::= "getSingleEsdt"

    rule .MxEsdtTransferList ~> getSingleEsdt => #exception(UserError, "incorrect number of ESDT transfers")
    rule _, _, _:MxEsdtTransferList ~> getSingleEsdt => #exception(UserError, "incorrect number of ESDT transfers")
    rule    ( mxTransferValue(... token: _:String, nonce: Nonce:Int, value: _:Int)
                , .MxEsdtTransferList
            ~> getSingleEsdt
            )
        => #exception(UserError, "fungible ESDT token expected")
        requires Nonce =/=Int 0
    rule    ( mxTransferValue(... token: TokenId:String, nonce: 0, value: Value:Int)
                , .MxEsdtTransferList
            ~> getSingleEsdt
            )
        => mxListValue(mxStringValue(TokenId), mxIntValue(Value))

endmodule

```

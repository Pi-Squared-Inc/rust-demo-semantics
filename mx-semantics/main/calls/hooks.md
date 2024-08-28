```k

module MX-CALLS-HOOKS
    imports private COMMON-K-CELL
    imports private INT
    imports private MX-CALL-CONFIGURATION
    imports private MX-CALL-TOOLS-SYNTAX
    imports private MX-COMMON-SYNTAX
    imports private STRING

    rule
        <k> MX#getCaller ( .MxValueList ) => mxStringValue(Caller) ... </k>
        <mx-caller> Caller:String </mx-caller>

    rule
        <k>
            MX#managedMultiTransferESDTNFTExecute
                ( mxStringValue(Destination:String)
                , mxTransfersValue(Transfers:MxEsdtTransferList)
                , mxIntValue(_Gas:Int)
                , mxStringValue("")  // Function name
                , mxListValue(.MxValueList)  // Other arguments
                )
            => (transferESDTs(Callee, Destination, Transfers) ~> mxIntValue(0))
            ...
        </k>
        <mx-callee> Callee:String </mx-callee>

    rule
        MX#managedMultiTransferESDTNFTExecute
            ( mxStringValue(Destination:String)
            , mxTransfersValue(Transfers:MxEsdtTransferList)
            , mxIntValue(GasLimit:Int)
            , mxStringValue(FunctionName:String)
            , mxListValue(Args:MxValueList)
            )
        => executeOnDestContext(Destination, 0, Transfers, GasLimit, FunctionName, Args)
        requires 0 <Int lengthString(FunctionName)

    rule [executeOnDestContext]:
        <k> executeOnDestContext
                (... destination: Destination:String
                , egldValue: Value:Int
                , esdtTransfers: Esdt:MxEsdtTransferList
                , gasLimit: GasLimit:Int
                , function: Func:String
                , args: Args:MxValueList
                )
            => callContract
                    ( Func
                    , prepareIndirectContractCallInput
                        (... caller: Callee
                        , callee: Destination
                        , egldValue: Value
                        , esdtTransfers: Esdt
                        , gasLimit: GasLimit
                        , args:Args
                        )
                    )
                ~> finishExecuteOnDestContext
            ...
        </k>
        <mx-callee> Callee </mx-callee>
endmodule

```
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
        => executeOnDestContext
            (... destination: Destination
            , egldValue: 0
            , esdtTransfers: Transfers
            , gasLimit: GasLimit
            , function: FunctionName
            , args: Args)
        requires 0 <Int lengthString(FunctionName)

    rule MX#managedExecuteOnDestContext
            ( mxStringValue(Destination:String)
            , mxIntValue(EgldValue:Int)
            , mxTransfersValue(Transfers:MxEsdtTransferList)
            , mxIntValue(GasLimit:Int)
            , mxStringValue(FunctionName:String)
            , mxListValue(Args:MxValueList)
            )
        => executeOnDestContext
            (... destination: Destination
            , egldValue: EgldValue
            , esdtTransfers: Transfers
            , gasLimit: GasLimit
            , function: FunctionName
            , args: Args
            )

    rule MX#finish ( V:MxValue ) => returnCallData(V)
endmodule

```
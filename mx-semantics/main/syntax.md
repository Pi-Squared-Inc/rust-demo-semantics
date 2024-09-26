```k

module MX-COMMON-SYNTAX
    imports BOOL-SYNTAX
    imports INT-SYNTAX
    imports STRING-SYNTAX

    syntax MxEsdtTransfer ::= mxTransferValue(token:String, nonce:Int, value:Int)
    syntax MxEsdtTransferList ::= List{MxEsdtTransfer, ","}

    syntax MxValue  ::= mxIntValue(Int)
                      | mxBoolValue(Bool)
                      | mxStringValue(String)
                      | mxListValue(MxValueList)
                      | MxEsdtTransfer
                      | mxTransfersValue(MxEsdtTransferList)
                      | mxUnitValue()
                      | MxEmptyValue
    syntax MxEmptyValue ::= "mxEmptyValue"

    syntax MxHookName ::= r"MX#[a-zA-Z][a-zA-Z0-9]*"  [token]
    syntax MxValueList ::= List{MxValue, ","}
    syntax HookCall ::= MxHookName "(" MxValueList ")"
    syntax MxValueList ::= reverse(MxValueList, MxValueList)  [function, total]

    syntax Int ::= lengthValueList(MxValueList)  [function, total]
    syntax String ::= getMxString(MxValue)  [function, total]
    syntax Int    ::= getMxUint(MxValue)    [function, total]

    syntax BuiltinFunction ::= "#notBuiltin"  [symbol(#notBuiltin)]
    syntax MxCallDataCell

    syntax MxInstructions ::= transferESDTs
                                  ( source: String
                                  , destination: String
                                  , transfers: MxEsdtTransferList
                                  )
                            | transferFunds(from: String, to: String, amount: Int)
                            | #exception(ExceptionCode, String)
                            | "pushCallState"  [symbol(pushCallState)]
                            | "popCallState"  [symbol(popCallState)]
                            | "resetCallState"  [symbol(resetCallState)]
                            | "pushWorldState"  [symbol(pushWorldState)]
                            | "dropWorldState"  [symbol(dropWorldState)]
                            | "popWorldState"  [symbol(popWorldState)]
                            | "clearBigInts"  [symbol(clearBigInts)]
                            | "endCall"  [symbol(endCall)]
                            | "finishExecuteOnDestContext"  [symbol(finishExecuteOnDestContext)]
                            | processBuiltinFunction(BuiltinFunction, String, String, MxCallDataCell)
                              [symbol(processBuiltinFunction)]
                            | newExecutionEnvironment(contractAddress:String)
                            | checkBool(Bool, String)   [symbol(checkBool)]
                            | storeHostValue(destination: MxValue, value: MxValue)
                            | returnCallData(MxValue)  [symbol(returnCallData)]
                            | mxGetBigInt(Int)  [symbol(mxGetBigInt)]
                            | callContract(function: String, input: MxCallDataCell )
                              [symbol(callContractString)]

    syntax MxHostInstructions ::= "host" "." "newEnvironment" "(" ContractCode ")"
                                | "host" "." "mkCall" "(" functionName:String ")"
                                | "host" "." "pushCallState"
                                | "host" "." "popCallState"
                                | "host" "." "resetCallState"

    syntax ContractCode ::= ".ContractCode"

    syntax MxCallResult ::= ".MxCallResult"
                          | mxCallResult
                              ( returnCode: ReturnCode
                              , returnMessage: String
                              , out: MxValue
                              ) [symbol(mxCallResult)]

    syntax ReturnCode    ::= "OK"          [symbol(OK)]
                           | ExceptionCode
    syntax ExceptionCode ::= "FunctionNotFound"         [symbol(FunctionNotFound)]         
                           | "FunctionWrongSignature"   [symbol(FunctionWrongSignature)]
                           | "ContractNotFound"         [symbol(ContractNotFound)]
                           | "UserError"                [symbol(UserError)]
                           | "OutOfGas"                 [symbol(OutOfGas)]
                           | "AccountCollision"         [symbol(AccountCollision)]
                           | "OutOfFunds"               [symbol(OutOfFunds)]
                           | "CallStackOverFlow"        [symbol(CallStackOverFlow)]
                           | "ContractInvalid"          [symbol(ContractInvalid)]
                           | "ExecutionFailed"          [symbol(ExecutionFailed)]
                           | "UpgradeFailed"            [symbol(UpgradeFailed)]
                           | "SimulateFailed"           [symbol(SimulateFailed)]

    syntax String ::= getCallee()  [function, total]

    syntax MxCallDataCell ::= prepareIndirectContractCallInput(
                                  caller: String,
                                  callee: String,
                                  egldValue: Int,
                                  esdtTransfers: MxEsdtTransferList,
                                  gasLimit: Int,
                                  args: MxValueList
                              )   [function, total]
endmodule

```

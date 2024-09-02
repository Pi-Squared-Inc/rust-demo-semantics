```k

module MX-COMMON-SYNTAX
    imports BOOL-SYNTAX
    imports INT-SYNTAX
    imports STRING-SYNTAX

    syntax MxEsdtTransfer ::= mxTransferValue(token:String, nonce:Int, value:Int)
    syntax MxEsdtTransferList ::= List{MxEsdtTransfer, ","}

    syntax MxValue  ::= mxIntValue(Int)
                      | mxStringValue(String)
                      | mxListValue(MxValueList)
                      | MxEsdtTransfer
                      | mxTransfersValue(MxEsdtTransferList)
                      | mxUnitValue()
    syntax MxHookName ::= r"MX#[a-zA-Z][a-zA-Z0-9]*"  [token]
    syntax MxValueList ::= List{MxValue, ","}
    syntax HookCall ::= MxHookName "(" MxValueList ")"

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
                            | processBuiltinFunction(BuiltinFunction, String, String, MxCallDataCell)
                              [symbol(processBuiltinFunction)]
                            | checkBool(Bool, String)    [symbol(checkBool)]

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
endmodule

```

```k

module MX-CALL-TOOLS-SYNTAX
    imports INT-SYNTAX 
    imports MX-CALL-CONFIGURATION
    imports STRING-SYNTAX

    syntax MxInstructions ::= executeOnDestContext(
                                  destination:String,
                                  egldValue:Int,
                                  esdtTransfers:MxEsdtTransferList,
                                  gasLimit:Int,
                                  function:String,
                                  args:MxValueList
                              )

    syntax MxCallDataCell ::= prepareIndirectContractCallInput(
                                  caller: String,
                                  callee: String,
                                  egldValue: Int,
                                  esdtTransfers: MxEsdtTransferList,
                                  gasLimit: Int,
                                  args: MxValueList
                              )   [function, total]

endmodule

module MX-CALLS-TOOLS
    imports private COMMON-K-CELL
    imports private INT
    imports private K-EQUAL-SYNTAX
    imports private MX-CALL-RESULT-CONFIGURATION
    imports private MX-CALL-TOOLS-SYNTAX
    imports private MX-COMMON-SYNTAX
    imports private STRING

    syntax MxInstructions ::= callContractAux
                                ( caller: String
                                , callee: String
                                , function: String
                                , input: MxCallDataCell
                                )
                              [symbol(callContractAux)]
                            | callContract(function: String, input: MxCallDataCell )
                              [symbol(callContractString)]
                            | "finishExecuteOnDestContext"  [symbol(finishExecuteOnDestContext)]
                            | "endCall"  [symbol(endCall)]
                            | "asyncExecute"  [symbol(asyncExecute)]
                            | "setVMOutput"  [symbol(setVMOutput)]

  // -----------------------------------------------------------------------------------
    rule prepareIndirectContractCallInput
            (...caller: Caller:String
            , callee: Callee:String
            , egldValue: EgldValue:Int
            , esdtTransfers: EsdtTransfers:MxEsdtTransferList
            , gasLimit: GasLimit:Int
            , args: Args:MxValueList
            )
        =>  <mx-call-data>
                <mx-callee> Callee </mx-callee>
                <mx-caller> Caller </mx-caller>
                <mx-call-args> Args </mx-call-args>
                <mx-egld-value> EgldValue </mx-egld-value>
                <mx-esdt-transfers> EsdtTransfers </mx-esdt-transfers>
                <mx-gas-provided> GasLimit </mx-gas-provided>
                <mx-gas-price> 0 </mx-gas-price>
            </mx-call-data>

  // -----------------------------------------------------------------------------------
    rule [callContract]:
        <k> callContract
                ( FunctionName:String
                ,   <mx-call-data>
                        <mx-callee> Callee </mx-callee>
                        <mx-caller> Caller </mx-caller>
                        <mx-egld-value> EgldValue </mx-egld-value>
                        <mx-esdt-transfers> EsdtTransfers </mx-esdt-transfers>
                        _
                    </mx-call-data> #as MxCallData
                )
            => pushWorldState
                ~> pushCallState
                ~> resetCallState
                ~> transferFunds(Caller, Callee, EgldValue)
                ~> transferESDTs(Caller, Callee, EsdtTransfers)
                ~> callContractAux
                    (... caller: Caller
                    , callee: Callee
                    , function: FunctionName
                    , input: MxCallData
                    )
                ~> endCall
            ...
        </k>
        <mx-call-result> _ => .MxCallResult </mx-call-result>

    rule [callContractAux-builtin]:
        callContractAux
            (... caller: From:String
            , callee: To:String
            , function: Function:String
            , input: MxCallData:MxCallDataCell
            )
        => processBuiltinFunction(toBuiltinFunction(Function), From, To, MxCallData)
        requires isBuiltin(Function)

    syntax Bool ::= isBuiltin(String)                        [function, total]
  // --------------------------------------------------------------------------
    rule isBuiltin(S:String) => toBuiltinFunction(S) =/=K #notBuiltin

    syntax BuiltinFunction ::= toBuiltinFunction(String)               [function, total]
  // --------------------------------------------------------------------------
    rule toBuiltinFunction(_:String)          => #notBuiltin           [owise]

  // --------------------------------------------------------------------------

    syntax BuiltinFunction ::= "#ESDTTransfer"        [symbol(#ESDTTransfer)]
    rule toBuiltinFunction(F) => #ESDTTransfer requires F ==String "ESDTTransfer"

    rule [ESDTTransfer]:
        processBuiltinFunction
            ( #ESDTTransfer
            , From:String
            , To:String
            ,   <mx-call-data>
                      <mx-egld-value> EgldValue </mx-egld-value>
                      <mx-call-args> Args </mx-call-args>
                      _
                </mx-call-data> #as MxCallData
            )
        => checkBool(EgldValue ==Int 0, "built in function called with tx value is not allowed")
            ~> checkBool(lengthValueList(Args) >=Int 2, "invalid arguments to process built-in function")
            // TODO ~> check transfer to meta
            // TODO ~> checkIfTransferCanHappenWithLimitedTransfer()
            ~> checkBool(ESDTTransfer.value(Args) >Int 0, "negative value")
            ~> transferESDTs(From, To, parseESDTTransfers(#ESDTTransfer, Args))
            ~> determineIsSCCallAfter(From, To, #ESDTTransfer, MxCallData)

    syntax String ::= "ESDTTransfer.token"  "(" MxValueList ")"   [function, total]
    syntax Int   ::= "ESDTTransfer.value" "(" MxValueList ")"    [function, total]
  // -----------------------------------------------------------------------------
    rule ESDTTransfer.token(ARGS) => getArgString(ARGS, 0)
    rule ESDTTransfer.value(ARGS) => getArgUInt(ARGS, 1)

    syntax MxValue ::= getArg(MxValueList, Int)        [function, total]
    syntax String  ::= getArgString(MxValueList, Int)  [function, total]
    syntax Int     ::= getArgUInt(MxValueList, Int)    [function, total]
  // ---------------------------------------------------------------
    rule getArg      (.MxValueList, _) => mxIntValue(0)
    rule getArg      (_Args, I)        => mxIntValue(0) requires I <Int 0
    rule getArg      ((A , _Args), 0)  => A
    rule getArg      ((_A , Args), I)  => getArg(Args, I -Int 1) requires I >Int 0
    rule getArgString(Args, I)         => getMxString(getArg(Args, I))
    rule getArgUInt  (ARGS, I)         => getMxUint(getArg(ARGS, I))

    syntax MxInstructions ::= determineIsSCCallAfter(String, String, BuiltinFunction, MxCallDataCell)
        [symbol(determineIsSCCallAfter)]
  // ----------------------------------------------
    rule [determineIsSCCallAfter-nocall]:
        determineIsSCCallAfter
            (_SND, _DST, FUNC
            ,   <mx-call-data>
                    <mx-call-args> Args:MxValueList </mx-call-args>
                    ...
                </mx-call-data>
            )
        => .K
        requires getCallFunc(FUNC, Args) ==K ""

    syntax String ::= getCallFunc(BuiltinFunction, MxValueList)  [function, total]
  // --------------------------------------------------------------------------
    rule getCallFunc(#ESDTTransfer,    ARGS) => getArgString(ARGS, 2) // token&amount&func&...
    // rule getCallFunc(#ESDTNFTTransfer, ARGS) => getArgString(ARGS, 4) // token&nonce&amount&dest&func&...
    // rule getCallFunc(#MultiESDTNFTTransfer, ARGS)
    //     => getArg(ARGS, MultiESDTNFTTransfer.num(ARGS) *Int 3 +Int 2)
    rule getCallFunc(_, _) => ""   [owise]

    syntax MxEsdtTransferList ::= parseESDTTransfers(BuiltinFunction, MxValueList)  [function, total]
  // ------------------------------------------------------------------------------------
    rule parseESDTTransfers(#ESDTTransfer, ARGS)
        => mxTransferValue(... token: ESDTTransfer.token(ARGS), nonce: 0, value: ESDTTransfer.value(ARGS)),
            .MxEsdtTransferList

    rule parseESDTTransfers(_, _) => .MxEsdtTransferList
        [owise]

  // ------------------------------------------------------
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

  // ------------------------------------------------------
    rule [finishExecuteOnDestContext-ok]:
        <k> finishExecuteOnDestContext => mxIntValue(0) ... </k>
        <mx-call-result> mxCallResult(... returnCode: OK) => .MxCallResult </mx-call-result>
 
    rule [finishExecuteOnDestContext-exception]:
        <k> finishExecuteOnDestContext => resolveErrorFromOutput(EC, MSG) ... </k>
        <mx-call-result> mxCallResult(... returnCode: EC:ExceptionCode, returnMessage: MSG) => .MxCallResult </mx-call-result>

    // TODO: This does not always return correct codes/messages. The messages
    // below are optimized for debugability.
    syntax MxInstructions ::= resolveErrorFromOutput(ExceptionCode, String) [function, total]
  // -----------------------------------------------------------------------
    rule resolveErrorFromOutput(ExecutionFailed, Msg:String)
        => #exception(ExecutionFailed, Msg)
    rule resolveErrorFromOutput(FunctionNotFound, Msg)
        => #exception(ExecutionFailed, "Function not found: " +String Msg)
    rule resolveErrorFromOutput(UserError, Msg)
        => #exception
                ( ExecutionFailed
                ,   #if Msg ==K "action is not allowed"
                    #then Msg
                    #else "error signalled by smartcontract: " +String Msg
                    #fi
                )
    rule resolveErrorFromOutput(OutOfFunds, Msg)
        => #exception(ExecutionFailed, "failed transfer (insufficient funds): " +String Msg)
    rule resolveErrorFromOutput(EC, Msg)
        => #exception(EC, Msg)
        [owise]

  // -----------------------------------------------------------------------
    rule [endCall]:
        endCall 
        => asyncExecute
            ~> setVMOutput
            ~> popCallState
            ~> dropWorldState

    rule [setVMOutput]:
        <k> setVMOutput => .K ... </k>
        <mx-call-result>
            _ => mxCallResult
                    (... returnCode: OK
                    , returnMessage: ""
                    , out: mxUnitValue()
                    )
        </mx-call-result>

    // TODO: Not implemented.
    rule asyncExecute => .K

    rule [[getCallee() => Callee]]
        <mx-callee> Callee:String </mx-callee>

endmodule

```

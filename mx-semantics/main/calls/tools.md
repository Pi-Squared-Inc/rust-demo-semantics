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

endmodule

module MX-CALLS-TOOLS
    imports private BOOL
    imports private COMMON-K-CELL
    imports private INT
    imports private K-EQUAL-SYNTAX
    imports private MX-CALL-RESULT-CONFIGURATION
    imports private MX-CALL-RETURN-VALUE-CONFIGURATION
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
                            | "asyncExecute"  [symbol(asyncExecute)]
                            | "setVMOutput"  [symbol(setVMOutput)]
                            | "clearMxReturnValues"
                            | mkCall(function: String, callData: MxCallDataCell)

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
                // TODO: clearMxReturnValues is not part of the actual MX semantics.
                // The MX semantics gathers all return values and makes them
                // available to whoever wants them. Usually, only the topmost one
                // (i.e., the return value for the last call) is interesting to
                // the caller.
                //
                // I'm unsure what happens for endpoints that do not return a
                // value (do they return an empty result? Does it not return a
                // result, and the caller simply does not try to read any
                // returned result?
                //
                // However, this is supposed to be a mx-lite implementation,
                // so we're assuming that nobody needs more than one return
                // result, so we can clear the returned results before each
                // call. At the end of the call, we check whether the results
                // list is empty or not to know if the endpoint returned
                // something.
                ~> clearMxReturnValues
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

    rule [callContractAux]:
        callContractAux
            (... caller: _From:String
            , callee: To:String
            , function: FuncName:String
            , input: CallData:MxCallDataCell
            )
        => newExecutionEnvironment(To)
            ~> mkCall(FuncName, CallData)
      requires notBool(isBuiltin(FuncName))
          andBool "callBack" =/=K FuncName

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

    rule [determineIsSCCallAfter-call]:
        determineIsSCCallAfter
            ( Sender:String, Destination:String, Func:BuiltinFunction
            ,   <mx-call-data>
                    <mx-call-args> Args:MxValueList </mx-call-args>
                    <mx-gas-provided> Gas:Int </mx-gas-provided>
                    <mx-gas-price> GasPrice:Int </mx-gas-price>
                    ...
                </mx-call-data>
            )
        => newExecutionEnvironment(Destination)
            ~> mkCall
                ( getCallFunc(Func, Args)
                , mkCallDataEsdtExec(Sender, Destination, Func, Args, Gas, GasPrice)
                )
      requires getCallFunc(Func, Args) =/=K ""


    syntax MxCallDataCell ::= mkCallDataEsdtExec
        (caller: String, callee: String
        , transferFunction: BuiltinFunction
        , args: MxValueList, gas: Int, gasPrice: Int)
        [function, total]
  // -----------------------------------------------------------------------------------
    rule mkCallDataEsdtExec
            (... caller: Caller:String
            , callee: Callee:String
            , transferFunction: Function:BuiltinFunction
            , args: Args:MxValueList
            , gas: Gas:Int, gasPrice: GasPrice:Int
            )
        =>  <mx-call-data>
                <mx-callee> Callee </mx-callee>
                <mx-caller> Caller </mx-caller>
                <mx-call-args> getCallArgs(Function, Args) </mx-call-args>
                <mx-egld-value> 0 </mx-egld-value>
                <mx-esdt-transfers> parseESDTTransfers(Function, Args) </mx-esdt-transfers>
                <mx-gas-provided> Gas </mx-gas-provided>
                <mx-gas-price> GasPrice </mx-gas-price>
            </mx-call-data>

    syntax MxValueList ::= getCallArgs(BuiltinFunction, MxValueList)  [function, total]
  // -------------------------------------------------------------------------------
    rule getCallArgs(#ESDTTransfer, Args:MxValueList)
        => drop(3, Args) // drop token, amount, func
    rule getCallArgs(_, _) => .MxValueList  [owise]

    syntax MxValueList ::= drop(Int, MxValueList)  [function, total]
  // -------------------------------------------------------------------------------
    rule drop(N:Int, Vs:MxValueList) => Vs
        requires N <=Int 0
    rule drop(N:Int, (_V:MxValue ,  Vs:MxValueList)) => drop(N -Int 1, Vs)
        requires 0 <Int N


    syntax String ::= getCallFunc(BuiltinFunction, MxValueList)  [function, total]
  // --------------------------------------------------------------------------
    rule getCallFunc(#ESDTTransfer,    Args) => getArgString(Args, 2) // token&amount&func&...
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
        <mx-call-result> mxCallResult(... returnCode: OK, out: Value:MxValue) => .MxCallResult </mx-call-result>
        <mx-return-values> .MxValueList => Value , .MxValueList </mx-return-values>

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
    rule
        <k> (V:MxValue => .K) ~> endCall ... </k>
        <mx-return-values> .MxValueList => V, .MxValueList </mx-return-values>

    rule [endCall]:
        endCall 
        => asyncExecute
            ~> setVMOutput
            ~> popCallState
            ~> dropWorldState

    rule [setVMOutput-no-retv]:
        <k> setVMOutput => .K ... </k>
        <mx-call-result>
            _ => mxCallResult
                    (... returnCode: OK
                    , returnMessage: ""
                    , out: mxUnitValue()
                    )
        </mx-call-result>
        <mx-return-values> .MxValueList </mx-return-values>

    rule [setVMOutput-with-retv]:
        <k> setVMOutput => .K ... </k>
        <mx-call-result>
            _ => mxCallResult
                    (... returnCode: OK
                    , returnMessage: ""
                    , out: ReturnValue
                    )
        </mx-call-result>
        <mx-return-values> ReturnValue:MxValue , .MxValueList => .MxValueList </mx-return-values>


    rule
        <k>
            mkCall
                (... function: FunctionName:String
                , callData: CallData:MxCallDataCell
                )
            => clearBigInts ~> host.mkCall(FunctionName)
            ...
        </k>
        (_:MxCallDataCell => CallData)

    rule
        <k> returnCallData(V:MxValue) => .K ... </k>
        <mx-return-values> .MxValueList => V , .MxValueList </mx-return-values>

    // TODO: Not implemented.
    rule asyncExecute => .K

    rule [[getCallee() => Callee]]
        <mx-callee> Callee:String </mx-callee>

    rule
        <k> clearMxReturnValues => .K ... </k>
        <mx-return-values> _ => .MxValueList </mx-return-values>

endmodule

```

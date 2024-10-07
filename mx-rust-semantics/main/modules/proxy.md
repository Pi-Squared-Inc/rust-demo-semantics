```k

module MX-RUST-MODULES-PROXY
    imports COMMON-K-CELL
    imports K-EQUAL-SYNTAX
    imports MX-RUST-REPRESENTATION
    imports RUST-EXECUTION-CONFIGURATION
    imports RUST-PREPROCESSING-CONFIGURATION
    imports RUST-REPRESENTATION
    imports RUST-SHARED-SYNTAX

    syntax MxRustType ::= "MxRust#Identifier"
                        | "MxRust#Tuple"

    syntax MxRustStructType ::= "proxyType"  [function, total]
    rule proxyType
        => rustStructType
            ( #token("MxRust#Proxy", "Identifier"):Identifier
            ,   ( mxRustStructField
                    ( #token("contract_address", "Identifier"):Identifier
                    , #token("ManagedAddress", "Identifier"):Identifier
                    )
                , mxRustStructField
                    ( #token("proxy_type", "Identifier"):Identifier
                    , MxRust#Type
                    )
                , mxRustStructField
                    ( #token("endpoint_name", "Identifier"):Identifier
                    , str
                    )
                , mxRustStructField
                    ( #token("args", "Identifier"):Identifier
                    , MxRust#Tuple
                    )
                , mxRustStructField
                    ( #token("return_type", "Identifier"):Identifier
                    , MxRust#Type
                    )
                , .MxRustStructFields
                )
            )

    rule
        <k>
            normalizedFunctionCall
                ( #token("MxRust#Proxy", "Identifier"):Identifier
                    :: #token("new", "Identifier"):Identifier
                , ptr(P1), ptr(P2), .PtrList
                )
            =>  mxRustNewStruct
                    ( proxyType
                    ,   ( ptrValue(ptr(P1), V1)
                        , ptrValue(ptr(P2), V2)
                        , ""
                        , ()
                        , ()
                        , .CallParamsList
                        )
                    )
            ...
        </k>
        <values>
            P1 |-> V1:Value
            P2 |-> V2:Value
            ...
        </values>

    rule
        <k>
            normalizedMethodCall
                ( #token("MxRust#Proxy", "Identifier"):Identifier
                    => ProxyType
                , _MethodName:Identifier
                , (ptr(SelfId:Int) , _Params:PtrList)
                )
            ...
        </k>
        <values>
            SelfId |-> struct
                    ( _
                    , #token("proxy_type", "Identifier"):Identifier |-> ProxyTypeId:Int
                      _:Map
                    )
            ProxyTypeId |-> rustType(ProxyType:TypePath)
            ...
        </values>
        <trait-path> ProxyType </trait-path>

    syntax RustMxInstruction ::= rustMxManagedExecuteOnDestContext
                                    ( destination: RustToMxOrInstruction  // RustToMx
                                    , egldValue: RustToMxOrInstruction  // RustToMx
                                    , mxTransfers: RustToMxOrInstruction  // RustToMx
                                    , gasLimit: RustToMxOrInstruction  // RustToMx
                                    , function: RustToMxOrInstruction  // RustToMx
                                    , args: RustToMxOrInstruction  // RustToMx
                                    )
    context rustMxManagedExecuteOnDestContext
        (... destination: HOLE:RustToMx => rustToMx(HOLE)
        , egldValue: _:RustToMx
        , mxTransfers: _:RustToMx
        , gasLimit: _:RustToMx
        , function: _:RustToMx
        , args: _:RustToMx
        )
        [result(MxValue)]
    context rustMxManagedExecuteOnDestContext
        (... destination: Destination:RustToMx
        , egldValue: HOLE:RustToMx => rustToMx(HOLE)
        , mxTransfers: _:RustToMx
        , gasLimit: _:RustToMx
        , function: _:RustToMx
        , args: _:RustToMx
        )
        requires isMxValue(Destination)
        [result(MxValue)]
    context rustMxManagedExecuteOnDestContext
        (... destination: Destination:RustToMx
        , egldValue: EgldValue:RustToMx
        , mxTransfers: HOLE:RustToMx => rustToMx(HOLE)
        , gasLimit: _:RustToMx
        , function: _:RustToMx
        , args: _:RustToMx
        )
        requires isMxValue(Destination)
            andBool isMxValue(EgldValue)
        [result(MxValue)]
    context rustMxManagedExecuteOnDestContext
        (... destination: Destination:RustToMx
        , egldValue: EgldValue:RustToMx
        , mxTransfers: MxTransfers:RustToMx
        , gasLimit: HOLE:RustToMx => rustToMx(HOLE)
        , function: _:RustToMx
        , args: _:RustToMx
        )
        requires isMxValue(Destination)
            andBool isMxValue(EgldValue)
            andBool isMxValue(MxTransfers)
        [result(MxValue)]
    context rustMxManagedExecuteOnDestContext
        (... destination: Destination:RustToMx
        , egldValue: EgldValue:RustToMx
        , mxTransfers: MxTransfers:RustToMx
        , gasLimit: GasLimit:RustToMx
        , function: HOLE:RustToMx => rustToMx(HOLE)
        , args: _:RustToMx
        )
        requires isMxValue(Destination)
            andBool isMxValue(EgldValue)
            andBool isMxValue(MxTransfers)
            andBool isMxValue(GasLimit)
        [result(MxValue)]
    context rustMxManagedExecuteOnDestContext
        (... destination: Destination:RustToMx
        , egldValue: EgldValue:RustToMx
        , mxTransfers: MxTransfers:RustToMx
        , gasLimit: GasLimit:RustToMx
        , function: Function:RustToMx
        , args: HOLE:RustToMx => rustToMx(HOLE)
        )
        requires isMxValue(Destination)
            andBool isMxValue(EgldValue)
            andBool isMxValue(MxTransfers)
            andBool isMxValue(GasLimit)
            andBool isMxValue(Function)
        [result(MxValue)]

    rule rustMxManagedExecuteOnDestContext
            (... destination: mxListValue(Destination:MxValue)
            , egldValue: EgldValue:MxValue
            , mxTransfers: MxTransfers:MxValue
            , gasLimit: GasLimit:MxValue
            , function: Function:MxValue
            , args: Args:MxValue
            )
        => MX#managedExecuteOnDestContext
            ( Destination
            , EgldValue
            , MxTransfers
            , GasLimit
            , Function
            , Args
            )

    rule
        <k>
            normalizedFunctionCall
                ( #token("MxRust#Proxy", "Identifier"):Identifier
                    :: #token("MxRust#execute_on_dest_context", "Identifier"):Identifier
                , (ptr(SelfId:Int) , .PtrList)
                )
            => rustMxManagedExecuteOnDestContext
                    (... destination: ContractAddress
                    , egldValue: mxIntValue(0)
                    , mxTransfers: mxTransfersValue(.MxEsdtTransferList)
                    , gasLimit: mxIntValue(0)
                    , function: EndpointName
                    , args: Args
                    )
                ~> mxRustCheckMxStatus
                ~> ptrValue(null, ())
            ...
        </k>
        <values>
            SelfId |-> struct
                    ( _
                    , #token("proxy_type", "Identifier"):Identifier
                        |-> _ProxyTypeId:Int
                      #token("contract_address", "Identifier"):Identifier
                        |-> ContractAddressId:Int
                      #token("endpoint_name", "Identifier"):Identifier
                        |-> EndpointNameId:Int
                      #token("args", "Identifier"):Identifier
                        |-> ArgsId:Int
                      #token("return_type", "Identifier"):Identifier
                        |-> _ReturnType:Int
                      .Map
                    )
            ContractAddressId |-> ContractAddress:Value
            EndpointNameId |-> EndpointName:Value
            ArgsId |-> Args:Value
            ...
        </values>

    rule implicitCast
            ( struct(#token("MxRust#Proxy", "Identifier"):Identifier, _) #as V
            , T
            ) => V
        requires leafTypePath(T) ==K #token("Proxy", "Identifier"):Identifier

    rule implicitCast
            ( V
            , #token("MxRust#CallReturnType", "Identifier"):Identifier
            ) => V

endmodule

```

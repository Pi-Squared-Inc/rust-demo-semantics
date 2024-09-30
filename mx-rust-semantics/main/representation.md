```k

module MX-RUST-REPRESENTATION
    imports MX-RUST-REPRESENTATION-CONVERSIONS
    imports MX-COMMON-SYNTAX
    imports MX-RUST-REPRESENTATION-CONVERSIONS
    imports RUST-REPRESENTATION
    imports RUST-SHARED-SYNTAX

    syntax MxRustInstruction  ::= "mxRustPreprocessTraits"
                                | mxRustPreprocessMethods(TypePath, TraitType)
                                | rustMxAddContractMethods(TypePath)
                                | rustMxAddProxyMethods(TypePath)
                                | mxRustCreateAccount(String)
                                | mxRustCreateContract
                                    ( owner: String
                                    , contractAccount: String
                                    , code: Crate
                                    , args: MxValueList)
                                | mxRustNewValue(ValueOrError)
                                | mxRustEmptyValue(MxRustType)
                                | mxValueToRust(Type)
                                // TODO: Replace with mxToRustTyped
                                | mxValueToRust(Type, MxValue)
                                | "rustValueToMx"
                                | rustValueToMx(Value)
                                | rustValuesToMx(ValueList, MxValueList)
                                | mxRustLoadPtr(Int)
                                | mxRustGetBigIntFromStruct(Value)
                                | mxRustGetStringFromId(Int)
                                | mxRustGetBuffer(Expression)  [strict]
                                | mxRustNewStruct(MxRustStructType, CallParamsList)
                                  [strict(2), result(ValueWithPtr)]
                                | "mxRustCheckMxStatus"
                                | rustMxCallHook(MxHookName, ValueListOrError)
                                | rustMxCallHookP(MxHookName, CallParamsList)
                                  [strict(2), result(ValueWithPtr)]
                                | "mxRustWrapInMxList"

    syntax TraitType ::= "contract" | "proxy"
    syntax MxRustType ::= "noType"
                        | rustType(Type)
                        | "MxRust#Type"
                        | "MxRust#buffer"

    syntax MxRustTypeOrError ::= MxRustType | SemanticsError
    syntax Value ::= MxRustType
    syntax Type ::= "bigUintFromValueType"  [function, total]
    syntax Type ::= "bigUintFromIdType"  [function, total]

    syntax RustToMxOrInstruction ::= RustToMx | MxRustInstruction

    syntax Expression ::= concatString(Expression, Expression)  [seqstrict]
                        | toString(Expression)  [strict]
                        | rawValue(Value)
                        | SemanticsError  // TODO: Remove.

    syntax MxValue ::= rustDestination(Int, MxRustType)
                    | mxRustType(MxRustType)

    syntax MxRustPreprocessedCell
    syntax PreprocessedCell
    syntax ContractCode ::= rustCode
                                ( endpointToFunction: MxRustPreprocessedCell
                                , preprocessed: PreprocessedCell
                                )
endmodule

module MX-RUST-REPRESENTATION-CONVERSIONS
    imports MX-COMMON-SYNTAX
    imports RUST-SHARED-SYNTAX
    imports RUST-VALUE-SYNTAX

    syntax MxRustStructField ::= mxRustStructField(Identifier, MxRustType)
    syntax MxRustStructFields ::= List{MxRustStructField, ","}
    syntax MxRustStructType ::= rustStructType(TypePath, MxRustStructFields)
    syntax Type ::= MxRustStructType
    syntax MxRustType ::= Type  // TODO: Remove and use `rustType(_)`

    syntax MxRustFieldValue ::= mxToRustField(Identifier, MxToRust)  [strict(2)]
    syntax MxRustFieldValueOrError ::= MxRustFieldValue | SemanticsError
    syntax MxRustFieldValues ::= List{MxRustFieldValueOrError, ","}

    syntax MxToRustIntermediate ::= mxToRustStruct(structName:TypePath, MxRustFieldValues)
                                    [strict(2), result(MxToRustFieldValue)]

    syntax MxToRustIntermediate ::= mxToRustTuple(MxToRustList)
                                    [strict, result(MxToRustValue)]

    syntax MxToRust ::= mxToRustTyped(MxRustType, MxValue)
                      | MxValue
                      | PtrValue
                      | SemanticsError
    syntax MxToRustOrError ::= MxToRust | SemanticsError
    syntax MxToRustList ::= List{MxToRustOrError, ","}

    syntax RustToMx ::= MxValue | Value
    syntax MxRustInstruction  ::= mxToRustTyped(MxRustType)
                                | mxToRustTypedExpression(Expression)
                                | mxToRustTypedExpression(Expression, MxValue)  [strict(1)]

    // TODO: Merge rustToMx and rustValueToMx
    syntax MxRustInstruction  ::= rustToMx(RustToMx)
                                | "rustToMx"
                                | rustValuesToMxListValue(ValueListOrError, MxValueList)
endmodule

```

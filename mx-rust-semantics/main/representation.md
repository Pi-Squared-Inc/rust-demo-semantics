```k

module MX-RUST-REPRESENTATION
    imports MX-RUST-REPRESENTATION-CONVERSIONS
    imports MX-COMMON-SYNTAX
    imports MX-RUST-REPRESENTATION-CONVERSIONS
    imports RUST-REPRESENTATION
    imports RUST-SHARED-SYNTAX

    syntax MxRustInstruction  ::= "mxRustPreprocessTraits"
                                | mxRustPreprocessMethods(TypePath, TraitType)
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
                                | mxValueToRust(Type, MxValue)
                                | "rustValueToMx"
                                | rustValueToMx(Value)
                                | rustValuesToMx(ValueList, MxValueList)
                                | mxRustLoadPtr(Int)
                                | mxRustGetBigIntFromStruct(Value)
                                | mxRustGetStringFromId(Int)
                                | mxRustNewStruct(MxRustStructType, CallParamsList)
                                  [strict(2), result(ValueWithPtr)]

    syntax TraitType ::= "contract" | "proxy"
    syntax MxRustType ::= "noType" | rustType(Type)
    syntax MxRustTypeOrError ::= MxRustType | SemanticsError
    syntax Value ::= MxRustType

    syntax Expression ::= concatString(Expression, Expression)  [seqstrict]
                        | toString(Expression)  [strict]
                        | rawValue(Value)
                        | SemanticsError  // TODO: Remove.

    syntax MxValue ::= rustDestination(Int, MxRustType)

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
    syntax MxRustType ::= Type  // TODO: Remove and use `rustType(_)`
                        | MxRustStructType

    syntax MxRustFieldValue ::= mxToRustField(Identifier, MxToRust)  [strict(2)]
    syntax MxRustFieldValueOrError ::= MxRustFieldValue | SemanticsError
    syntax MxRustFieldValues ::= List{MxRustFieldValueOrError, ","}

    syntax MxToRustIntermediate ::= mxToRustStruct(structName:TypePath, MxRustFieldValues)
                                    [strict(2), result(MxToRustFieldValue)]

    syntax MxToRust ::= mxToRustTyped(MxRustType, MxValue)
                      | MxValue
                      | PtrValue
                      | SemanticsError

    syntax MxOrRustValue ::= MxValue | Value
    syntax MxOrRustValueList ::= List{MxOrRustValue, ","}
    syntax MxOrRustValueListOrError ::= MxOrRustValueList | SemanticsError
    syntax MxRustInstruction ::= mxToRustTyped(MxRustType)

    syntax MxRustInstruction  ::= rustToMx(MxOrRustValue)
                                | "rustToMx"
endmodule

```

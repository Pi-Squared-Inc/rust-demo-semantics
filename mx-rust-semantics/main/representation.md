```k

module MX-RUST-REPRESENTATION
    imports MX-COMMON-SYNTAX
    imports RUST-REPRESENTATION
    imports RUST-SHARED-SYNTAX

    syntax MxRustInstruction  ::= "mxRustPreprocessTraits"
                                | mxRustPreprocessMethods(TypePath)
                                | mxRustCreateAccount(String)
                                | mxRustCreateContract(owner: String, contractAccount: String, code: Crate)
                                | mxRustNewValue(ValueOrError)
                                | mxRustEmptyValue(MxRustType)
                                | mxValueToRust(Type)
                                | mxValueToRust(Type, MxValue)
                                | rustValueToMx(Value)
                                | rustValuesToMx(ValueList, MxValueList)
                                | mxRustLoadPtr(Int)
                                | mxRustGetBigIntFromStruct(Value)

    syntax MxRustType ::= "noType" | rustType(Type)
    syntax MxRustTypeOrError ::= MxRustType | SemanticsError
    syntax Value ::= MxRustType

    syntax SemanticsError ::= unknownMxRustType(GenericArg)

    syntax Expression ::= concatString(Expression, Expression)  [seqstrict]
                        | toString(Expression)  [strict]

    syntax MxValue ::= rustDestination(Int, MxRustType)

    syntax PreprocessedCell
    syntax ContractCode ::= rustCode(endpointToFunction: Map, type: TypePath, preprocessed: PreprocessedCell)
endmodule

```

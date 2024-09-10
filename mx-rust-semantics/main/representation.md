```k

module MX-RUST-REPRESENTATION
    imports RUST-REPRESENTATION
    imports RUST-SHARED-SYNTAX

    syntax MxRustInstruction  ::= "mxRustPreprocessTraits"
                                | mxRustPreprocessMethods(TypePath)
                                | mxRustNewValue(ValueOrError)
                                | mxValueToRust(Type)
                                | mxRustLoadPtr(Int)

    syntax MxRustType ::= "BigUint"
    syntax MxRustTypeOrError ::= MxRustType | SemanticsError
    syntax Value ::= MxRustType

    syntax SemanticsError ::= unknownMxRustType(GenericArg)

    syntax MxWrappedValue ::= wrappedRust(Value)

    syntax Expression ::= concatString(Expression, Expression)  [seqstrict]
                        | toString(Expression)  [strict]

    syntax MxValue ::= rustDestination(Int)
endmodule

```

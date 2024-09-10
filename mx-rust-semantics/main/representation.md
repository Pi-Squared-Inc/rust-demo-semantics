```k

module MX-RUST-REPRESENTATION
    imports RUST-SHARED-SYNTAX

    syntax MxRustInstruction  ::= "mxRustPreprocessTraits"
                                | mxRustPreprocessMethods(TypePath)

    syntax MxRustType ::= "BigUint"
    syntax MxRustTypeOrError ::= MxRustType | SemanticsError
    syntax Value ::= MxRustType

    syntax SemanticsError ::= unknownMxRustType(GenericArg)

    syntax Expression ::= concatString(Expression, Expression)  [seqstrict]
                        | toString(Expression)  [strict]
endmodule

```

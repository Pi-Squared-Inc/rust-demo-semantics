```k

module RUST-PREPROCESSING-SYNTAX
    imports RUST-SHARED-SYNTAX

    syntax Initializer ::= crateParser(crate: Crate)
endmodule

module RUST-PREPROCESSING-PRIVATE-SYNTAX
    imports LIST
    imports MAP
    imports RUST-REPRESENTATION
    imports RUST-SHARED-SYNTAX

    syntax Initializer  ::= traitParser(Trait)
                          | traitMethodsParser(AssociatedItems, traitName:Identifier)
                          | traitInitializer
                                ( traitName: TypePath
                                )

    syntax Initializer  ::= addMethod(traitName : TypePath, function: Function, atts:OuterAttributes)
                          | #addMethod(
                                TypePath,
                                Identifier,
                                NormalizedFunctionParameterListOrError,
                                Type,
                                BlockExpressionOrSemicolon,
                                OuterAttributes
                            )

    // TODO: Move to a more generic place
    syntax Identifier ::= "self"  [token]
endmodule

```

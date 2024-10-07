```k

module RUST-PREPROCESSING-SYNTAX
    imports RUST-CRATE-LIST-SYNTAX
    imports RUST-SHARED-SYNTAX

    syntax Initializer  ::= cratesParser(crates: WrappedCrateList)
                          | crateParser(crate: Crate, crateModule: TypePath)
endmodule

module RUST-PREPROCESSING-PRIVATE-SYNTAX
    imports LIST
    imports MAP
    imports RUST-REPRESENTATION
    imports RUST-SHARED-SYNTAX

    syntax Initializer  ::= traitParser(Trait, MaybeTypePath, OuterAttributes)
                          | traitMethodsParser(AssociatedItems, traitName:TypePath)
                          | traitInitializer
                                ( traitName: TypePath
                                , atts: OuterAttributes
                                )
    syntax Initializer  ::= moduleParser(Module, TypePath)
                          | moduleItemsParser(Items, TypePath)
                          | constantParser(ConstantItem, TypePath)  [strict(1)]
                          | resolveCrateNames(TypePath)

    syntax Initializer  ::= addMethod(traitName : TypePath, function: Function, atts:OuterAttributes)
                          | #addMethod(
                                TypePath,
                                Identifier,
                                NormalizedFunctionParameterListOrError,
                                Type,
                                BlockExpressionOrSemicolon,
                                OuterAttributes
                            )

endmodule

```

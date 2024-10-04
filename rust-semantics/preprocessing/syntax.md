```k

module RUST-PREPROCESSING-SYNTAX
    imports RUST-CRATE-LIST-SYNTAX
    imports RUST-SHARED-SYNTAX

    syntax Initializer  ::= cratesParser(crates: WrappedCrateList)
                          | crateParser(crate: Crate)
endmodule

module RUST-PREPROCESSING-PRIVATE-SYNTAX
    imports LIST
    imports MAP
    imports RUST-REPRESENTATION
    imports RUST-SHARED-SYNTAX

    syntax MaybeTypePath ::= ".TypePath" | TypePath

    syntax Initializer  ::= traitParser(Trait, MaybeTypePath, OuterAttributes)
                          | traitMethodsParser(AssociatedItems, traitName:TypePath)
                          | traitInitializer
                                ( traitName: TypePath
                                , atts: OuterAttributes
                                )
    syntax Initializer  ::= moduleParser(Module)
                          | moduleItemsParser(Items, TypePath)


    syntax Initializer  ::= addMethod(traitName : TypePath, function: Function, atts:OuterAttributes)
                          | #addMethod(
                                TypePath,
                                Identifier,
                                NormalizedFunctionParameterListOrError,
                                Type,
                                BlockExpressionOrSemicolon,
                                OuterAttributes
                            )

    syntax TypePath ::= append(MaybeTypePath, Identifier)  [function, total]
endmodule

```

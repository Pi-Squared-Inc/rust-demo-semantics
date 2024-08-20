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
                          | traitMethodsParser(AssociatedItems, functions: Map, traitName:Identifier)
                          | constantInitializer
                                ( constantNames: List, constants: Map )
                          | traitInitializer
                                ( traitName: TypePath
                                )
                          | traitMethodInitializer
                                ( traitName: TypePath
                                , functionNames:List, functions: Map
                                )

    syntax Initializer  ::= addMethod(traitName : TypePath, function: Function, atts:OuterAttributes)
                          | addMethod1(
                                TypePath,
                                FunctionWithWhere, BlockExpressionOrSemicolon,
                                OuterAttributes
                            )
                          | addMethod2(
                                TypePath,
                                FunctionWithParams, Type,
                                BlockExpressionOrSemicolon, OuterAttributes
                            )
                          | addMethod3(
                                TypePath,
                                Identifier, NormalizedFunctionParameterList,
                                FunctionParameterList, Type,
                                BlockExpressionOrSemicolon, OuterAttributes
                            )
                          | addMethod4(
                                TypePath,
                                Identifier, NormalizedFunctionParameterList, Type,
                                BlockExpressionOrSemicolon, OuterAttributes
                            )

    // TODO: Move to a more generic place
    syntax Identifier ::= "self"  [token]
endmodule

```

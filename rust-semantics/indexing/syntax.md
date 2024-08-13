```k

module RUST-INDEXING-SYNTAX
    imports RUST-SHARED-SYNTAX

    syntax Initializer ::= crateParser(crate: Crate)
endmodule

module RUST-INDEXING-PRIVATE-SYNTAX
    imports LIST
    imports MAP
    imports RUST-REPRESENTATION
    imports RUST-SHARED-SYNTAX

    syntax Initializer  ::= traitParser(Trait)
                          | traitMethodsParser(AssociatedItems, functions: Map, traitName:Identifier)
                          | crateInitializer
                                ( constantNames:List, constants: Map
                                , traitName: Identifier
                                , functionNames:List, functions: Map
                                )

    syntax Initializer  ::= addMethod(function: Function, atts:OuterAttributes)
                          | addMethod1(
                                FunctionWithWhere, BlockExpressionOrSemicolon,
                                OuterAttributes
                            )
                          | addMethod2(
                                FunctionWithParams, Type,
                                BlockExpressionOrSemicolon, OuterAttributes
                            )
                          | addMethod3(
                                Identifier, NormalizedFunctionParameterList,
                                FunctionParameterList, Type,
                                BlockExpressionOrSemicolon, OuterAttributes
                            )
                          | addMethod4(
                                Identifier, NormalizedFunctionParameterList, Type,
                                BlockExpressionOrSemicolon, OuterAttributes
                            )

    // TODO: Move to a more generic place
    syntax Identifier ::= "self"  [token]
endmodule

```

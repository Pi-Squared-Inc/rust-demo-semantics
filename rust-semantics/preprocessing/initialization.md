```k

module INITIALIZATION
    imports private COMMON-K-CELL
    imports private RUST-CONVERSIONS-SYNTAX
    imports private RUST-PREPROCESSING-CONFIGURATION
    imports private RUST-PREPROCESSING-PRIVATE-HELPERS
    imports private RUST-PREPROCESSING-PRIVATE-SYNTAX

    rule
        <k> traitInitializer(Name:TypePath, Atts:OuterAttributes) => .K
            ...
        </k>
        <trait-list> .List => ListItem(Name) ...</trait-list>
        <traits>
            ...
            .Bag
            =>  <trait>
                    <trait-path> Name </trait-path>
                    <trait-attributes> Atts </trait-attributes>
                    ...
                </trait>
        </traits>

    rule addMethod(Trait:TypePath, F:Function, A:OuterAttributes)
        => #addMethod
            ( Trait
            , getFunctionName(F)
            , extractFunctionNormalizedParams(F)
            , getFunctionReturnType(F)
            , getFunctionBlockOrSemicolon(F)
            , A
            )

    rule
        <k> #addMethod(
                Trait:TypePath,
                Name:Identifier, P:NormalizedFunctionParameterList,
                R:Type, B:BlockExpressionOrSemicolon,
                A:OuterAttributes
            ) => .K
            ...
        </k>
        <trait>
          ...
          <trait-path> Trait </trait-path>
          <method-list> L:List => ListItem(Name) L </method-list>
        </trait>
        <methods>
          .Bag =>
            <method>
              <method-name> typePathToPathInExpression(append(Trait, Name)) </method-name>
              <method-params> P </method-params>
              <method-return-type> R </method-return-type>
              <method-implementation> toFBR(B) </method-implementation>
              <method-outer-attributes> A </method-outer-attributes>
            </method>
          ...
        </methods>

    syntax FunctionBodyRepresentation ::= toFBR(BlockExpressionOrSemicolon)  [function, total]
    rule toFBR(B:BlockExpression) => block(B)
    rule toFBR(;) => empty

endmodule

```

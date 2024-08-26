```k

module INITIALIZATION
    imports private RUST-RUNNING-CONFIGURATION
    imports private RUST-PREPROCESSING-PRIVATE-HELPERS
    imports private RUST-PREPROCESSING-PRIVATE-SYNTAX

    rule
        <k> traitInitializer(Name:TypePath) => .K
            ...
        </k>
        <traits>
            ...
            .Bag
            =>  <trait>
                    <trait-path> Name </trait-path>
                    <methods> .Bag </methods>
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
                R:Type, B:BlockExpression,
                A:OuterAttributes
            ) => .K
            ...
        </k>
        <trait>
          ...
          <trait-path> Trait </trait-path>
          <methods>
            .Bag =>
              <method>
                <method-name> Name:Identifier </method-name>
                <method-params> P </method-params>
                <method-return-type> R </method-return-type>
                <method-implementation> block(B) </method-implementation>
                <method-outer-attributes> A </method-outer-attributes>
              </method>
            ...
          </methods>
        </trait>

endmodule

```

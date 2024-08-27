```k

module INITIALIZATION
    imports private COMMON-K-CELL
    imports private RUST-PREPROCESSING-CONFIGURATION
    imports private RUST-PREPROCESSING-PRIVATE-HELPERS
    imports private RUST-PREPROCESSING-PRIVATE-SYNTAX

    rule (.K => addMethod(TraitName, F, A))
          ~> traitMethodInitializer
              ( ... traitName : TraitName:TypePath
              , functionNames: (ListItem(Name:Identifier:KItem) => .List) _Names:List
              , functions: _Functions:Map
                ((Name:Identifier:KItem |-> (A:OuterAttributes F:Function):AssociatedItem) => .Map)
              )
    rule traitMethodInitializer(... functionNames: .List) => .K

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
                _A:OuterAttributes
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
              </method>
            ...
          </methods>
        </trait>

endmodule

```

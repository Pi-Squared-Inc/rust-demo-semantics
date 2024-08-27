```k

module CRATE
    imports private COMMON-K-CELL
    imports private LIST
    imports private MAP
    imports private RUST-PREPROCESSING-PRIVATE-SYNTAX
    imports private RUST-PREPROCESSING-SYNTAX
    imports private RUST-REPRESENTATION

    syntax Initializer  ::= crateParser(crate: Crate, traitName: MaybeIdentifier, traitFunctions: Map)

    rule crateParser(C:Crate) => crateParser(... crate : C, traitName : .Identifier, traitFunctions : .Map)

    rule crateParser
        ( ... crate:
          (_Atts:InnerAttributes (_A:OuterAttributes _U:UseDeclaration):Item Is:Items):Crate
          => (.InnerAttributes Is):Crate
        , traitName : _Name:MaybeIdentifier
        , traitFunctions: _TraitFunctions:Map
        )
    rule
        (.K => traitParser(T))
        ~> crateParser
          ( ... crate:
            (_Atts:InnerAttributes (ItemAtts:OuterAttributes _V:MaybeVisibility T:Trait):Item Is:Items):Crate
            => (.InnerAttributes (ItemAtts T):Item Is):Crate
          , traitName : .Identifier
          , traitFunctions: .Map
          )
    rule  ( traitMethodsParser(.AssociatedItems, Functions:Map, Name:Identifier)
          => .K
          )
          ~> crateParser
            ( ... crate:
              (_Atts:InnerAttributes (_ItemAtts:OuterAttributes _T:Trait):Item Is:Items):Crate
              => (.InnerAttributes Is):Crate
            , traitName : .Identifier => Name
            , traitFunctions: .Map => Functions
            )

    rule (.K => CI:ConstantItem:KItem)
        ~> crateParser
          ( ... crate:
            (Atts:InnerAttributes (_ItemAtts:OuterAttributes _:MaybeVisibility CI:ConstantItem):Item Is:Items):Crate
            => (Atts Is):Crate
          , traitName : _Name:MaybeIdentifier
          , traitFunctions: _TraitFunctions:Map
          )

    rule
        crateParser
            ( ... crate: (_Atts:InnerAttributes .Items):Crate
            , traitName : Name:Identifier
            , traitFunctions: Functions:Map
            )
          => traitInitializer(Name)
          ~> traitMethodInitializer
              ( ... traitName: Name
              , functionNames:keys_list(Functions), functions: Functions
              )
endmodule

```

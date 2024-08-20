```k

module CRATE
    imports private LIST
    imports private MAP
    imports private RUST-PREPROCESSING-PRIVATE-SYNTAX
    imports private RUST-PREPROCESSING-SYNTAX
    imports private RUST-REPRESENTATION
    imports private RUST-RUNNING-CONFIGURATION

    syntax MaybeIdentifier ::= ".Identifier" | Identifier
    syntax Initializer  ::= crateParser(crate: Crate, constants: Map, traitName: MaybeIdentifier, traitFunctions: Map)

    rule crateParser(C:Crate) => crateParser(... crate : C, constants : .Map, traitName : .Identifier, traitFunctions : .Map)

    rule crateParser
        ( ... crate:
          (_Atts:InnerAttributes (_A:OuterAttributes _U:UseDeclaration):Item Is:Items):Crate
          => (.InnerAttributes Is):Crate
        , constants : _Constants:Map
        , traitName : _Name:MaybeIdentifier
        , traitFunctions: _TraitFunctions:Map
        )
    rule
        (.K => traitParser(T))
        ~> crateParser
          ( ... crate:
            (_Atts:InnerAttributes (ItemAtts:OuterAttributes _V:MaybeVisibility T:Trait):Item Is:Items):Crate
            => (.InnerAttributes (ItemAtts T):Item Is):Crate
          , constants : _Constants:Map
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
            , constants : _Constants:Map
            , traitName : .Identifier => Name
            , traitFunctions: .Map => Functions
            )

    // rule (.K => CI:ConstantItem:KItem)
    //     ~> crateParser
    //       ( ... crate:
    //         (Atts:InnerAttributes (_ItemAtts:OuterAttributes CI:ConstantItem):Item Is:Items):Crate
    //         => (Atts Is):Crate
    //       , constants : _Constants:Map
    //       , traitName : _Name:MaybeIdentifier
    //       , traitFunctions: _TraitFunctions:Map
    //       )
    // rule ((const Name:Identifier : _T:Type = V:Value;):ConstantItem:KItem => .K)
    //     ~> crateParser
    //         ( ... crate : _C:Crate
    //         , constants : Constants:Map => Constants[Name:Identifier:KItem <- V:Value:KItem]
    //         , traitName : _Name:MaybeIdentifier
    //         , traitFunctions: _TraitFunctions:Map
    //         )

    rule
        crateParser
            ( ... crate: (_Atts:InnerAttributes .Items):Crate
            , constants : Constants:Map
            , traitName : Name:Identifier
            , traitFunctions: Functions:Map
            )
          => constantInitializer
              ( ... constantNames: keys_list(Constants), constants: Constants )
          ~> traitInitializer(Name)
          ~> traitMethodInitializer
              ( ... traitName: Name
              , functionNames:keys_list(Functions), functions: Functions
              )
endmodule

```

```k

module CRATE
    imports private COMMON-K-CELL
    imports private LIST
    imports private MAP
    imports private RUST-PREPROCESSING-PRIVATE-SYNTAX
    imports private RUST-PREPROCESSING-SYNTAX
    imports private RUST-REPRESENTATION

    rule crateParser
        ( (_Atts:InnerAttributes (_A:OuterAttributes _U:UseDeclaration):Item Is:Items):Crate
          => (.InnerAttributes Is):Crate
        , _:TypePath
        )
    rule (.K => moduleParser(M, CratePath))
        ~> crateParser
          ( (_Atts:InnerAttributes (_ItemAtts:OuterAttributes _V:MaybeVisibility M:Module):Item Is:Items):Crate
            => (.InnerAttributes Is):Crate
          , CratePath:TypePath
          )
    rule
        (.K => traitParser(T, CratePath, ItemAtts))
        ~> crateParser
          ( (_Atts:InnerAttributes (ItemAtts:OuterAttributes _V:MaybeVisibility T:Trait):Item Is:Items):Crate
            => (.InnerAttributes Is):Crate
          , CratePath:TypePath
          )
    rule (.K => constantParser(CI:ConstantItem, CratePath))
        ~> crateParser
          ( (Atts:InnerAttributes (_ItemAtts:OuterAttributes _:MaybeVisibility CI:ConstantItem):Item Is:Items):Crate
            => (Atts Is):Crate
          , CratePath:TypePath
          )

    rule crateParser( (_Atts:InnerAttributes .Items):Crate, _Path:TypePath)
        => .K //resolveCrateNames(Path)
endmodule

```

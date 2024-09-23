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
        )
    rule
        (.K => traitParser(T, ItemAtts))
        ~> crateParser
          ( (_Atts:InnerAttributes (ItemAtts:OuterAttributes _V:MaybeVisibility T:Trait):Item Is:Items):Crate
            => (.InnerAttributes Is):Crate
          )
    rule (.K => CI:ConstantItem:KItem)
        ~> crateParser
          ( (Atts:InnerAttributes (_ItemAtts:OuterAttributes _:MaybeVisibility CI:ConstantItem):Item Is:Items):Crate
            => (Atts Is):Crate
          )

    rule crateParser( (_Atts:InnerAttributes .Items):Crate) => .K
endmodule

```

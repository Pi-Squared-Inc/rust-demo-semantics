```k

module CRATE
    imports private LIST
    imports private MAP
    imports private RUST-PREPROCESSING-PRIVATE-SYNTAX
    imports private RUST-PREPROCESSING-SYNTAX
    imports private RUST-REPRESENTATION
    imports private RUST-RUNNING-CONFIGURATION

    rule crateParser
        ( (_Atts:InnerAttributes (_A:OuterAttributes _U:UseDeclaration):Item Is:Items):Crate
          => (.InnerAttributes Is):Crate
        )
    rule
        (.K => traitParser(T))
        ~> crateParser
          ( (_Atts:InnerAttributes (_ItemAtts:OuterAttributes _V:MaybeVisibility T:Trait):Item Is:Items):Crate
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

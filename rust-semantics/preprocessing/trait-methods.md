```k

module TRAIT-METHODS
    imports private RUST-PREPROCESSING-PRIVATE-HELPERS
    imports private RUST-PREPROCESSING-PRIVATE-SYNTAX

    rule  traitMethodsParser(.AssociatedItems, _Name:TypePath)
          => .K
    rule (.K => addMethod(TraitName, F, A))
        ~> traitMethodsParser(
              (A:OuterAttributes F:Function) AIs:AssociatedItems => AIs,
              TraitName:TypePath
          )
endmodule

```

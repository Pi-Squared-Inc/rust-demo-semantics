```k

module RUST-MODULE
    imports private RUST-PREPROCESSING-PRIVATE-SYNTAX

    rule moduleParser
            ( mod Name:Identifier { _:InnerAttributes Contents:Items }
            , ParentPath:TypePath
            )
        => moduleItemsParser(Contents, append(ParentPath, Name))

    rule moduleItemsParser(.Items, _Name) => .K
    rule
        (.K => traitParser(T, Name, ItemAtts))
        ~> moduleItemsParser
          ( (ItemAtts:OuterAttributes _V:MaybeVisibility T:Trait):Item Is:Items
            => Is
          , Name
          )
    rule
        moduleItemsParser
          ( (_OuterAttributes _:MacroItem):Item Is:Items
            => Is
          , _Name
          )
endmodule

```

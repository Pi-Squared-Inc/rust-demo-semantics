```k

module RUST-PREPROCESSING-EXTERN-BLOCK
    imports private RUST-PREPROCESSING-PRIVATE-SYNTAX

    rule externBlockParser
            ( _:MaybeUnsafe extern _:MaybeAbi { .InnerAttributes .ExternalItems }
            , _Parent:TypePath
            )
        => .K

    rule externBlockParser
            ( _:MaybeUnsafe extern _:MaybeAbi
                  { .InnerAttributes
                      (Atts:OuterAttributes _:MaybeVisibility Fn:Function)
                      Items:ExternalItems
                  }
            , Parent:TypePath
            )
        => functionParser(Fn, Parent, Atts)
            ~> externBlockParser(extern {.InnerAttributes Items}, Parent)

endmodule

```

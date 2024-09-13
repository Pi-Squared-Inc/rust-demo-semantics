```k

module TRAIT
    imports private RUST-PREPROCESSING-PRIVATE-SYNTAX

    rule traitParser
            ( trait Name:Identifier { .InnerAttributes Functions:AssociatedItems }
            , Path:MaybeTypePath
            , ItemAtts:OuterAttributes
            )
        => traitInitializer(append(Path, Name), ItemAtts)
          ~> traitMethodsParser(Functions, append(Path, Name))
endmodule

```

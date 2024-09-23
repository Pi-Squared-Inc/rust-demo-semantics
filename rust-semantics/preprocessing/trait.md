```k

module TRAIT
    imports private RUST-PREPROCESSING-PRIVATE-SYNTAX

    rule traitParser
          ( trait Name:Identifier { .InnerAttributes Functions:AssociatedItems }
          , ItemAtts:OuterAttributes
          )
        => traitInitializer(Name, ItemAtts)
          ~> traitMethodsParser(Functions, Name)
endmodule

```

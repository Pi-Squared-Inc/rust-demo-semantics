```k

module TRAIT
    imports private RUST-PREPROCESSING-PRIVATE-SYNTAX

    rule traitParser(trait Name:Identifier { .InnerAttributes Functions:AssociatedItems })
        => traitInitializer(Name)
          ~> traitMethodsParser(Functions, Name)
endmodule

```

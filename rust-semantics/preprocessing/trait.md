```k

module TRAIT
    imports private RUST-PREPROCESSING-PRIVATE-SYNTAX

    rule traitParser(trait Name:Identifier { .InnerAttributes Functions:AssociatedItems })
        => traitMethodsParser(Functions, .Map, Name)
endmodule

```

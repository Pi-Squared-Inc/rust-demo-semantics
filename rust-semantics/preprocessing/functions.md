```k

module RUST-PREPROCESSING-FUNCTIONS
    imports private RUST-PREPROCESSING-PRIVATE-SYNTAX

    rule functionParser(F:Function, Parent:TypePath, Atts:OuterAttributes)
        => addFunction(Parent, F, Atts)
endmodule

```

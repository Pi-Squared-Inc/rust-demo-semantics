```k

module TRAIT-METHODS
    imports private RUST-INDEXING-PRIVATE-HELPERS
    imports private RUST-INDEXING-PRIVATE-SYNTAX

    rule traitMethodsParser(
            (A:OuterAttributes F:Function) AIs:AssociatedItems => AIs,
            Functions => Functions[getFunctionName(F):Identifier:KItem <- (A F):AssociatedItem],
            _Name:Identifier
        )
endmodule

```

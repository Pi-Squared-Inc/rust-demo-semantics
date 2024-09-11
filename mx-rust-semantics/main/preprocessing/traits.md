```k

module MX-RUST-PREPROCESSING-TRAITS
    imports private COMMON-K-CELL
    imports private LIST
    imports private MX-RUST-REPRESENTATION
    imports private RUST-PREPROCESSING-CONFIGURATION
    imports private RUST-SHARED-SYNTAX

    syntax MxRustInstruction  ::= mxRustPreprocessTraits(List)
                                | mxRustPreprocessTrait(TypePath)

    rule
        <k>
            mxRustPreprocessTraits => mxRustPreprocessTraits(Traits)
            ...
        </k>
        <trait-list> Traits:List </trait-list>

    rule mxRustPreprocessTraits(.List) => .K
    rule mxRustPreprocessTraits(ListItem(Trait:TypePath) Traits:List)
        => mxRustPreprocessTrait(Trait) ~> mxRustPreprocessTraits(Traits)

    rule mxRustPreprocessTrait(Trait:TypePath) => mxRustPreprocessMethods(Trait)
endmodule

```

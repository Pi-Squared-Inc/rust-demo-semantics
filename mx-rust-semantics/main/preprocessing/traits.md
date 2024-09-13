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

    rule
        <k>
            mxRustPreprocessTrait(Trait:TypePath) => mxRustPreprocessMethods(Trait, contract)
            ...
        </k>
        <trait-path> Trait </trait-path>
        <trait-attributes>
            #[ #token("multiversx_sc", "Identifier")
                :: #token("contract", "Identifier")
                :: .SimplePathList
            ]
            .NonEmptyOuterAttributes
        </trait-attributes>
    rule
        <k>
            mxRustPreprocessTrait(Trait:TypePath) => mxRustPreprocessMethods(Trait, proxy)
            ...
        </k>
        <trait-path> Trait </trait-path>
        <trait-attributes>
            #[ #token("multiversx_sc", "Identifier")
                :: #token("proxy", "Identifier")
                :: .SimplePathList
            ]
            .NonEmptyOuterAttributes
        </trait-attributes>
endmodule

```

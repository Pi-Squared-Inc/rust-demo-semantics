```k

module MX-RUST-PREPROCESSING-TRAITS
    imports private COMMON-K-CELL
    imports private LIST
    imports private MX-RUST-PREPROCESSED-CONTRACT-TRAIT-CONFIGURATION
    imports private MX-RUST-PREPROCESSED-PROXIES-CONFIGURATION
    imports private MX-RUST-REPRESENTATION
    imports private RUST-PREPROCESSING-CONFIGURATION
    imports private RUST-REPRESENTATION
    imports private RUST-SHARED-SYNTAX

    syntax MxRustInstruction  ::= mxRustPreprocessAddTraits(List)
                                | mxRustPreprocessAddTrait(TypePath)
                                | mxRustPreprocessTraits(List)
                                | mxRustPreprocessTrait(TypePath)
                                | mxRustPreprocessAddProxy(TypePathOrError, TypePath)

    rule
        <k>
            mxRustPreprocessTraits
            => mxRustPreprocessAddTraits(Traits) ~> mxRustPreprocessTraits(Traits)
            ...
        </k>
        <trait-list> Traits:List </trait-list>

    rule mxRustPreprocessAddTraits(.List) => .K
    rule mxRustPreprocessAddTraits(ListItem(Trait:TypePath) Traits:List)
        => mxRustPreprocessAddTrait(Trait) ~> mxRustPreprocessAddTraits(Traits)

    rule mxRustPreprocessTraits(.List) => .K
    rule mxRustPreprocessTraits(ListItem(Trait:TypePath) Traits:List)
        => mxRustPreprocessTrait(Trait) ~> mxRustPreprocessTraits(Traits)

    rule
        <k>
            mxRustPreprocessAddTrait(Trait:TypePath) => .K
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
        <mx-rust-contract-trait> _ => Trait </mx-rust-contract-trait>
    rule
        <k>
            mxRustPreprocessAddTrait(Trait:TypePath)
            => mxRustPreprocessAddProxy(parentTypePath(Trait), Trait)
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

    rule
        <k>
            mxRustPreprocessTrait(Trait:TypePath)
            => mxRustPreprocessMethods(Trait, contract)
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
            mxRustPreprocessTrait(Trait:TypePath)
            => mxRustPreprocessMethods(Trait, proxy)
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

    rule
        <k>
            mxRustPreprocessAddProxy(Module:TypePath, Trait:TypePath)
            => .K
            ...
        </k>
        <mx-rust-proxies>
            .Bag
            =>  <mx-rust-proxy>
                    <mx-rust-proxy-module> Module </mx-rust-proxy-module>
                    <mx-rust-proxy-trait> Trait </mx-rust-proxy-trait>
                </mx-rust-proxy>
            ...
        </mx-rust-proxies>
endmodule

```

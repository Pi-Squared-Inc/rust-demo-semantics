```k

module ULM-PREPROCESSING-TRAITS
    imports private COMMON-K-CELL
    imports private RUST-PREPROCESSING-CONFIGURATION
    imports private ULM-PREPROCESSING-CONFIGURATION
    imports private ULM-PREPROCESSING-SYNTAX-PRIVATE

    rule ulmPreprocessTraits(.List) => .K
    rule ulmPreprocessTraits(ListItem(T:TypePath) Traits:List)
        => ulmPreprocessTrait(T) ~> ulmPreprocessTraits(Traits)

    rule
        <k>
            ulmPreprocessTrait(Trait:TypePath)
            => ulmPreprocessMethods(Trait, Methods) ~> ulmAddDispatcher(Trait)
            ...
        </k>
        <trait-path> Trait </trait-path>
        <trait-attributes>
            #[ #token("ulm", "Identifier")
                :: #token("contract", "Identifier")
                :: .SimplePathList
            ]
            .NonEmptyOuterAttributes
        </trait-attributes>
        <method-list> Methods:List </method-list>
        <ulm-contract-trait> _ => Trait </ulm-contract-trait>

    // There should be an owise rule rewriting ulmPreprocessTrait(_) to .K
    // For now, it is probably more useful to stop execution when encountering
    // an unknown trait than skipping it.
endmodule

```

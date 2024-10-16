```k

module UKM-PREPROCESSING-TRAITS
    imports private COMMON-K-CELL
    imports private RUST-PREPROCESSING-CONFIGURATION
    imports private UKM-PREPROCESSING-CONFIGURATION
    imports private UKM-PREPROCESSING-SYNTAX-PRIVATE

    rule ukmPreprocessTraits(.List) => .K
    rule ukmPreprocessTraits(ListItem(T:TypePath) Traits:List)
        => ukmPreprocessTrait(T) ~> ukmPreprocessTraits(Traits)

    rule
        <k>
            ukmPreprocessTrait(Trait:TypePath)
            => ukmPreprocessMethods(Trait, Methods) ~> ukmAddDispatcher(Trait)
            ...
        </k>
        <trait-path> Trait </trait-path>
        <trait-attributes>
            #[ #token("ukm", "Identifier")
                :: #token("contract", "Identifier")
                :: .SimplePathList
            ]
            .NonEmptyOuterAttributes
        </trait-attributes>
        <method-list> Methods:List </method-list>
        <ukm-contract-trait> _ => Trait </ukm-contract-trait>

    // There should be an owise rule rewriting ukmPreprocessTrait(_) to .K
    // For now, it is probably more useful to stop execution when encountering
    // an unknown trait than skipping it.
endmodule

```

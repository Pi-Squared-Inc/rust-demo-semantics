```k

module ULM-PREPROCESSING-CRATES
    imports private COMMON-K-CELL
    imports private RUST-PREPROCESSING-CONFIGURATION
    imports private ULM-PREPROCESSING-SYNTAX
    imports private ULM-PREPROCESSING-SYNTAX-PRIVATE

    rule
        <k> ulmPreprocessCrates => ulmPreprocessTraits(Traits) ... </k>
        <trait-list> Traits:List </trait-list>
endmodule

```

```k

module UKM-PREPROCESSING-CRATES
    imports private COMMON-K-CELL
    imports private RUST-PREPROCESSING-CONFIGURATION
    imports private UKM-PREPROCESSING-SYNTAX
    imports private UKM-PREPROCESSING-SYNTAX-PRIVATE

    rule
        <k> ukmPreprocessCrates => ukmPreprocessTraits(Traits) ... </k>
        <trait-list> Traits:List </trait-list>
endmodule

```

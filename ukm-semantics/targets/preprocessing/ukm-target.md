```k

requires "../../main/encoding.md"
requires "../../main/preprocessing.md"
// requires "blockchain-k-plugin/plugin/krypto.md"
requires "configuration.md"

module UKM-TARGET-SYNTAX
endmodule

module UKM-TARGET
    imports private RUST-FULL-PREPROCESSING
    imports private UKM-ENCODING
    imports private UKM-PREPROCESSING
    imports private UKM-TARGET-CONFIGURATION
    // imports KRYPTO
endmodule

```

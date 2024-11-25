```k

requires "../../main/configuration.md"
requires "../../main/preprocessed-configuration.md"
requires "rust-semantics/config.md"

module COMMON-K-CELL
    imports private BYTES-SYNTAX
    imports private INT-SYNTAX
    imports private RUST-PREPROCESSING-SYNTAX
    imports private ULM-DECODING-SYNTAX
    imports private ULM-EXECUTION-SYNTAX
    imports private ULM-PREPROCESSING-SYNTAX

    configuration
        <k>
            cratesParser(ulmDecodeRustCrates($PGM:Bytes))
            ~> ulmPreprocessCrates
            ~> ulmExecute($CREATE:Bool, $PGM:Bytes, $ACCTCODE:Int, $GAS:Int)
        </k>
endmodule

module ULM-TARGET-CONFIGURATION
    imports COMMON-K-CELL
    imports RUST-EXECUTION-CONFIGURATION
    imports ULM-CONFIGURATION
    imports ULM-FULL-PREPROCESSED-CONFIGURATION
    imports ULM-PREPROCESSING-EPHEMERAL-CONFIGURATION

    configuration
        <ulm-preprocessing-ephemeral/>
        <ulm-full-preprocessed/>
        <ulm/>
        <execution/>
        <k/>

endmodule

```

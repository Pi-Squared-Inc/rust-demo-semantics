```k

requires "../../main/configuration.md"
requires "../../main/preprocessed-configuration.md"
requires "rust-semantics/config.md"

module COMMON-K-CELL
    imports private BYTES-SYNTAX
    imports private INT-SYNTAX
    imports private ULM-DECODING-SYNTAX
    imports private ULM-EXECUTION-SYNTAX

    configuration
        <k>
            ulmDecodePreprocessedCell($PGM:Bytes)
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

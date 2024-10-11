```k

requires "../../main/configuration.md"
requires "../../main/preprocessed-configuration.md"
requires "rust-semantics/config.md"

module COMMON-K-CELL
    imports private BYTES-SYNTAX
    imports private INT-SYNTAX
    imports private UKM-DECODING-SYNTAX
    imports private UKM-EXECUTION-SYNTAX

    configuration
        <k>
            ukmDecodePreprocessedCell($PGM:Bytes)
            ~> ukmExecute($ACCTCODE:Int, $GAS:Int)
        </k>
endmodule

module UKM-TARGET-CONFIGURATION
    imports COMMON-K-CELL
    imports RUST-EXECUTION-CONFIGURATION
    imports UKM-CONFIGURATION
    imports UKM-FULL-PREPROCESSED-CONFIGURATION

    configuration
        <ukm-target>
            <ukm-full-preprocessed/>
            <ukm/>
            <execution/>
            <k/>
        </ukm-target>
endmodule

```

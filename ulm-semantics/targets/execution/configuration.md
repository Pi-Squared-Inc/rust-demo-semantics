```k

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

```

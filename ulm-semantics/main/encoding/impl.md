```k

module ULM-ENCODING-IMPL
    imports private COMMON-K-CELL
    imports private BYTES-SYNTAX
    imports private ULM-ENCODING-SYNTAX
    imports private ULM-FULL-PREPROCESSED-CONFIGURATION

    syntax Bytes  ::= encodeUlmFullPreprocessedCell(UlmFullPreprocessedCell)
                      [function, hook(ULM.encode)]

    rule
        <k>
            ulmEncodePreprocessedCell
            => ulmEncodedPreprocessedCell(encodeUlmFullPreprocessedCell(Cell))
            ...
        </k>
        Cell:UlmFullPreprocessedCell

endmodule

```

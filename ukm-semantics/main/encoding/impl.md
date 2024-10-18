```k

module UKM-ENCODING-IMPL
    imports private COMMON-K-CELL
    imports private BYTES-SYNTAX
    imports private UKM-ENCODING-SYNTAX
    imports private UKM-FULL-PREPROCESSED-CONFIGURATION

    syntax Bytes  ::= encodeUkmFullPreprocessedCell(UkmFullPreprocessedCell)
                      [function, hook(ULM.encode)]

    rule
        <k>
            ukmEncodePreprocessedCell
            => ukmEncodedPreprocessedCell(encodeUkmFullPreprocessedCell(Cell))
            ...
        </k>
        Cell:UkmFullPreprocessedCell

endmodule

```

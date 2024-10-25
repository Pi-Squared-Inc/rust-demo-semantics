```k

module ULM-PREPROCESSING-CELL-SYNTAX

    syntax UlmFullPreprocessedCell
    syntax ULMInstruction ::= "ulmExtractPreprocessedCell"
                            | ulmPreprocessedContract(UlmFullPreprocessedCell)  [symbol(ulmPreprocessedContract)]

endmodule

module ULM-PREPROCESSING-CELL
    imports private COMMON-K-CELL
    imports private BYTES-SYNTAX
    imports private ULM-PREPROCESSING-CELL-SYNTAX
    imports private ULM-FULL-PREPROCESSED-CONFIGURATION

    rule
        <k>
            ulmExtractPreprocessedCell
            => ulmPreprocessedContract(Cell)
            ...
        </k>
        Cell:UlmFullPreprocessedCell

endmodule

```

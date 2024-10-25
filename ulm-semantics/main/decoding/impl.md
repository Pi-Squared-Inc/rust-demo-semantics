```k

module ULM-DECODING-IMPL
    imports private COMMON-K-CELL
    imports private ULM-DECODING-SYNTAX
    imports private ULM-FULL-PREPROCESSED-CONFIGURATION

    syntax UlmFullPreprocessedCell  ::= decodeUlmFullPreprocessedCell(Bytes)
                                        [function, hook(ULM.decode)]

    rule
        <k> ulmDecodePreprocessedCell(B:Bytes) => .K ... </k>
        (_:UlmFullPreprocessedCell => decodeUlmFullPreprocessedCell(B))
endmodule

```

```k

module UKM-DECODING-IMPL
    imports private COMMON-K-CELL
    imports private UKM-DECODING-SYNTAX
    imports private UKM-FULL-PREPROCESSED-CONFIGURATION

    syntax UkmFullPreprocessedCell  ::= decodeUkmFullPreprocessedCell(Bytes)
                                        [function, hook(ULM.decode)]

    rule
        <k> ukmDecodePreprocessedCell(B:Bytes) => .K ... </k>
        (_:UkmFullPreprocessedCell => decodeUkmFullPreprocessedCell(B))
endmodule

```

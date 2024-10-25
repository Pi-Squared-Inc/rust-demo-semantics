```k

module ULM-DECODING-IMPL
    imports private COMMON-K-CELL
    imports private RUST-PREPROCESSING-SYNTAX
    imports private ULM-DECODING-SYNTAX
    imports private ULM-FULL-PREPROCESSED-CONFIGURATION

    syntax WrappedCrateList ::= decodeWrappedCrateList(Bytes)
                                    [function, hook(ULM.decode)]

    rule ulmDecodeParseContract(B:Bytes) => cratesParser(decodeWrappedCrateList(B))
endmodule

```

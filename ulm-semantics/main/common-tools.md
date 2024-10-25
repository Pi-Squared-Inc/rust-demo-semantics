```k

module ULM-COMMON-TOOLS-SYNTAX
    syntax Identifier ::= "dispatcherMethodIdentifier"  [function, total]
endmodule

module ULM-COMMON-TOOLS
    imports private ULM-COMMON-TOOLS-SYNTAX

    rule dispatcherMethodIdentifier => #token("ulm#dispatch#method", "Identifier")
endmodule

```
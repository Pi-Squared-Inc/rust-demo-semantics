```k

module UKM-COMMON-TOOLS-SYNTAX
    syntax Identifier ::= "dispatcherMethodIdentifier"  [function, total]
endmodule

module UKM-COMMON-TOOLS
    imports private UKM-COMMON-TOOLS-SYNTAX

    rule dispatcherMethodIdentifier => #token("ukm#dispatch#method", "Identifier")
endmodule

```
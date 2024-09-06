```k

module RUST-EXPRESSION-CONSTANTS
    imports private COMMON-K-CELL
    imports private RUST-SHARED-SYNTAX
    imports private RUST-REPRESENTATION
    imports private RUST-PREPROCESSING-CONFIGURATION

    rule <k> Name:Identifier::.PathExprSegments => ptrValue(null, V) ... </k>
        <constant-name> Name </constant-name>
        <constant-value> V:Value </constant-value>

endmodule
```
```k

module RUST-EXPRESSION-CONSTANTS
    imports private COMMON-K-CELL
    imports private RUST-SHARED-SYNTAX
    imports private RUST-REPRESENTATION
    imports private RUST-PREPROCESSING-CONFIGURATION

    rule <k> Name:Identifier => ptrValue(null, V) ... </k>
        <constant-name> Name </constant-name>
        <constant-value> V:Value </constant-value>
        requires notBool isLocalVariable(Name)

    rule [[isConstant(Name:Identifier) => true]]
        <constant-name> Name </constant-name>
        requires notBool isLocalVariable(Name)
    rule isConstant(_Name:ValueName) => false  [owise]
endmodule
```
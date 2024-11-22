```k

requires "../../main/configuration.md"
requires "../../main/preprocessed-configuration.md"
requires "rust-semantics/config.md"

module COMMON-K-CELL
    imports private BYTES-SYNTAX
    imports private INT-SYNTAX
    imports private RUST-PREPROCESSING-SYNTAX
    imports private RUST-VALUE-SYNTAX
    imports private ULM-DECODING-SYNTAX
    imports private ULM-EXECUTION-SYNTAX
    imports private ULM-PREPROCESSING-SYNTAX

    syntax Identifier ::= "myConstantA"  [token]
                        | "myConstantB"  [token]

    syntax KItem  ::= addConstant(PathInExpression, Value)
                    | "encodeDecodeConstants"
                    | checkConstant(PathInExpression, Value)
                    | removeConstant(PathInExpression)

    configuration
        <k>
            addConstant(myConstantA :: .PathExprSegments, u64(1p64))
            ~> addConstant(myConstantB :: .PathExprSegments, u64(2p64))

            ~> encodeDecodeConstants

            ~> checkConstant(myConstantA :: .PathExprSegments, u64(1p64))
            ~> checkConstant(myConstantB :: .PathExprSegments, u64(2p64))

            ~> removeConstant(myConstantA :: .PathExprSegments)
            ~> removeConstant(myConstantB :: .PathExprSegments)
        </k>
endmodule

module ULM-TARGET-CONFIGURATION
    imports COMMON-K-CELL
    imports RUST-EXECUTION-CONFIGURATION
    imports RUST-REPRESENTATION
    imports RUST-VALUE-SYNTAX
    imports ULM-CONFIGURATION
    imports ULM-FULL-PREPROCESSED-CONFIGURATION
    imports ULM-PREPROCESSING-EPHEMERAL-CONFIGURATION

    rule
        <k> addConstant(Name:PathInExpression, V:Value) => .K ... </k>
        <constants>
            .Bag => <constant>
                <constant-name> Name </constant-name>
                <constant-value> V </constant-value>
            </constant>
            ...
        </constants>
    rule
        <k> removeConstant(Name:PathInExpression) => .K ... </k>
        <constants>
            <constant>
                <constant-name> Name </constant-name>
                <constant-value> _ </constant-value>
            </constant> => .Bag
            ...
        </constants>
    rule
        <k> checkConstant(Name:PathInExpression, Val:Value) => .K ... </k>
        <constants>
            <constant>
                <constant-name> Name </constant-name>
                <constant-value> Val </constant-value>
            </constant>
            ...
        </constants>
    rule
        <k> encodeDecodeConstants => fromEncodedConstants(encodeConstants(Constants)) ... </k>
        Constants:ConstantsCell

    syntax KItem ::= fromEncodedConstants(Bytes)
    rule
        <k> fromEncodedConstants(EncodedConstants:Bytes) => .K ... </k>
        (_:ConstantsCell => decodeConstants(EncodedConstants))

    syntax Bytes ::= encodeConstants(ConstantsCell)  [function, total, hook(ULM.encode)]
    syntax ConstantsCell ::= decodeConstants(Bytes)  [function, total, hook(ULM.decode)]

    configuration
        <ulm-preprocessing-ephemeral/>
        <ulm-full-preprocessed/>
        <ulm/>
        <execution/>
        <k/>

endmodule

```

```k
module RUST-CONSTANTS
    imports private RUST-CASTS
    imports private RUST-REPRESENTATION
    imports private RUST-RUNNING-CONFIGURATION
    imports private RUST-SHARED-SYNTAX

    syntax KItem ::= setConstant(Identifier, ValueOrError)

    rule
        (const Name:Identifier : T:Type = V:Value;):ConstantItem:KItem
        => setConstant(Name, cast(V, T))

    rule
        <k>
            setConstant(Name, V:Value) => .K
            ...
        </k>
        <constants>
            .Bag => <constant>
                <constant-name> Name </constant-name>
                <constant-value> V </constant-value>
            </constant>
            ...
        </constants>
endmodule
```
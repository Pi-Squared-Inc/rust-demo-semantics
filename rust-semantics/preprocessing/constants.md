```k
module RUST-CONSTANTS
    imports private COMMON-K-CELL
    imports private RUST-CASTS
    imports private RUST-PREPROCESSING-CONFIGURATION
    imports private RUST-REPRESENTATION
    imports private RUST-SHARED-SYNTAX

    syntax KItem ::= setConstant(Identifier, ValueOrError)

    rule
        (const Name:Identifier : T:Type = V:Value;):ConstantItem:KItem
        => setConstant(Name, implicitCast(V, T)) 

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
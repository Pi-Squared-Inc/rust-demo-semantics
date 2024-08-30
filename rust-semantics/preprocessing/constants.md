```k
module RUST-CONSTANTS
    imports private COMMON-K-CELL
    imports private RUST-CASTS
    imports private RUST-PREPROCESSING-CONFIGURATION
    imports private RUST-REPRESENTATION
    imports private RUST-SHARED-SYNTAX

    syntax KItem ::= setConstant(Identifier, ValueOrError)
                   | getConstant(Identifier)

    rule
        (const Name:Identifier : T:Type = V:Value;):ConstantItem:KItem
        => setConstant(Name, implicitCast(V, T))

    rule Name:Identifier::_:PathExprSegments => getConstant(Name) [owise]

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

    rule
        <k>
            getConstant(Name) => V
            ...
        </k>
        <constants>
            <constant>
                <constant-name> Name </constant-name>
                <constant-value> V:Value </constant-value>
            </constant>
            ...
        </constants>


endmodule
```
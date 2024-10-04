```k
module RUST-CONSTANTS
    imports private COMMON-K-CELL
    imports private RUST-CASTS
    imports private RUST-CONVERSIONS-SYNTAX
    imports private RUST-PREPROCESSING-CONFIGURATION
    imports private RUST-PREPROCESSING-PRIVATE-SYNTAX
    imports private RUST-REPRESENTATION
    imports private RUST-SHARED-SYNTAX

    syntax KItem ::= setConstant(TypePath, ValueOrError)

    rule isKResult((const _:Identifier : _T:Type = ptrValue(_, _);):ConstantItem:KItem) => true

    rule
        constantParser
            ( const Name:Identifier : T:Type = ptrValue(_, V:Value);
            , ParentPath:TypePath
            )
        => setConstant(append(ParentPath, Name), implicitCast(V, T))

    rule
        <k>
            setConstant(Path, V:Value) => .K
            ...
        </k>
        <constants>
            .Bag => <constant>
                <constant-name> typePathToPathInExpression(Path) </constant-name>
                <constant-value> V </constant-value>
            </constant>
            ...
        </constants>
endmodule
```
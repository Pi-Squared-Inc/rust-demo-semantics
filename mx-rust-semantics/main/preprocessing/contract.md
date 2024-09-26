```k

module MX-RUST-PREPROCESSING-CONTRACT
    imports COMMON-K-CELL
    imports MX-RUST-REPRESENTATION
    imports RUST-PREPROCESSING-CONFIGURATION

    syntax MxRustInstruction ::= rustMxAddContractSend(TypePath)

    rule rustMxAddContractMethods(Trait:TypePath)
        => rustMxAddContractSend(Trait:TypePath)

    rule
        <k>
            rustMxAddContractSend(Trait:TypePath)
            => error
                ( "send already exists for trait"
                , ListItem(Trait)
                )
            ...
        </k>
        <trait-path> Trait </trait-path>
        <method-name> #token("send", "Identifier") </method-name>
        [priority(50)]

    rule
        <k>
            rustMxAddContractSend(Trait:TypePath)
            => .K
            ...
        </k>
        <trait-path> Trait </trait-path>
        ( .Bag
            =>  <method>
                    <method-name> #token("send", "Identifier") </method-name>
                    <method-params> self : $selftype , .NormalizedFunctionParameterList </method-params>
                    <method-return-type> #token("MxRust#CallReturnType", "Identifier") </method-return-type>
                    <method-implementation>
                        block({
                            .InnerAttributes
                            (
                                (
                                    (  #token("MxRust#Send", "Identifier")
                                    :: (#token("new", "Identifier"):PathExprSegment)
                                    :: .PathExprSegments
                                    )
                                    ( .CallParamsList )
                                ):Expression
                            ):Statements
                        })
                    </method-implementation>
                    <method-outer-attributes> `emptyOuterAttributes`(.KList):OuterAttributes </method-outer-attributes>
                </method>
        )
        [priority(100)]

endmodule

```

```k

module MX-RUST-PREPROCESSING-CONTRACT
    imports private COMMON-K-CELL
    imports private MX-RUST-REPRESENTATION
    imports private RUST-CONVERSIONS-SYNTAX
    imports private RUST-PREPROCESSING-CONFIGURATION

    syntax MxRustInstruction  ::= rustMxAddContractSend(TypePath)
                                | rustMxAddContractCallValue(TypePath)
                                | rustMxAddContractBlockchain(TypePath)
                                | rustMxAddContractGenericMethod
                                    ( trait: TypePath
                                    , method: Identifier
                                    , struct: Identifier
                                    )
                                | rustMxAddContractGenericMethod
                                    ( method: PathInExpression
                                    , struct: Identifier
                                    )

    rule rustMxAddContractMethods(Trait:TypePath)
        => rustMxAddContractSend(Trait:TypePath)
            ~> rustMxAddContractCallValue(Trait:TypePath)
            ~> rustMxAddContractBlockchain(Trait:TypePath)

    rule rustMxAddContractSend(Trait:TypePath)
        => rustMxAddContractGenericMethod
            (... trait: Trait
            , method: #token("send", "Identifier")
            , struct: #token("MxRust#Send", "Identifier")
            )

    rule rustMxAddContractCallValue(Trait:TypePath)
        => rustMxAddContractGenericMethod
            (... trait: Trait
            , method: #token("call_value", "Identifier")
            , struct: #token("MxRust#CallValue", "Identifier")
            )

    rule rustMxAddContractBlockchain(Trait:TypePath)
        => rustMxAddContractGenericMethod
            (... trait: Trait
            , method: #token("blockchain", "Identifier")
            , struct: #token("MxRust#Blockchain", "Identifier")
            )

    rule rustMxAddContractGenericMethod
            (... trait: Trait:TypePath
            , method: Method:Identifier
            , struct: Identifier
            )
        => rustMxAddContractGenericMethod
            (... method: typePathToPathInExpression(append(Trait, Method))
            , struct: Identifier
            )

    rule
        <k>
            rustMxAddContractGenericMethod
                (... method: Method:PathInExpression
                )
            => error
                ( "method already exists for trait"
                , ListItem(Method)
                )
            ...
        </k>
        <method-name> Method </method-name>
        [priority(50)]

    rule
        <k>
            rustMxAddContractGenericMethod
                (... method: Method:PathInExpression
                , struct: Struct:Identifier
                )
            => .K
            ...
        </k>
        ( .Bag
            =>  <method>
                    <method-name> Method </method-name>
                    <method-params> self : $selftype , .NormalizedFunctionParameterList </method-params>
                    <method-return-type> #token("MxRust#CallReturnType", "Identifier") </method-return-type>
                    <method-implementation>
                        block({
                            .InnerAttributes
                            (
                                (
                                    (  Struct
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

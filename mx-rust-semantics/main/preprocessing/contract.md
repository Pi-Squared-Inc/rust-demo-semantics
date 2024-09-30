```k

module MX-RUST-PREPROCESSING-CONTRACT
    imports COMMON-K-CELL
    imports MX-RUST-REPRESENTATION
    imports RUST-PREPROCESSING-CONFIGURATION

    syntax MxRustInstruction  ::= rustMxAddContractSend(TypePath)
                                | rustMxAddContractCallValue(TypePath)
                                | rustMxAddContractBlockchain(TypePath)
                                | rustMxAddContractGenericMethod
                                    ( trait: TypePath
                                    , method: Identifier
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

    rule
        <k>
            rustMxAddContractGenericMethod
                (... trait: Trait:TypePath
                , method: Method:Identifier
                )
            => error
                ( "send already exists for trait"
                , ListItem(Trait)
                )
            ...
        </k>
        <trait-path> Trait </trait-path>
        <method-name> Method </method-name>
        [priority(50)]

    rule
        <k>
            rustMxAddContractGenericMethod
                (... trait: Trait:TypePath
                , method: Method:Identifier
                , struct: Struct:Identifier
                )
            => .K
            ...
        </k>
        <trait-path> Trait </trait-path>
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

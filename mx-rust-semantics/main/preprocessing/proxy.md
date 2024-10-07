```k

module MX-RUST-PREPROCESSING-PROXY
    imports COMMON-K-CELL
    imports MX-RUST-REPRESENTATION
    imports RUST-CONVERSIONS-SYNTAX
    imports RUST-PREPROCESSING-CONFIGURATION

    syntax MxRustInstruction ::= rustMxAddProxyEodtMethod(PathInExpression)

    rule rustMxAddProxyMethods(Trait:TypePath)
        => rustMxAddProxyEodtMethod
            ( typePathToPathInExpression
                ( append(Trait, #token("execute_on_dest_context", "Identifier"))
                )
            )

    rule
        <k>
            rustMxAddProxyEodtMethod(Name:PathInExpression)
            => error
                ( "execute_on_dest_context already exists for trait"
                , ListItem(Name)
                )
            ...
        </k>
        <method-name> Name </method-name>
        [priority(50)]

    rule
        <k>
            rustMxAddProxyEodtMethod(Name:PathInExpression)
            => .K
            ...
        </k>
        ( .Bag
            =>  <method>
                    <method-name> Name </method-name>
                    <method-params> self : $selftype , .NormalizedFunctionParameterList </method-params>
                    <method-return-type> #token("MxRust#CallReturnType", "Identifier") </method-return-type>
                    <method-implementation>
                        block({
                            .InnerAttributes
                            (
                                (
                                    (  #token("MxRust#Proxy", "Identifier")
                                    :: (#token("MxRust#execute_on_dest_context", "Identifier"):PathExprSegment)
                                    :: .PathExprSegments
                                    )
                                    ( self, .CallParamsList )
                                ):Expression;
                                (
                                    (  #token("MxRust#Hooks", "Identifier")
                                    :: (#token("MxRust#loadMxReturnValue", "Identifier"):PathExprSegment)
                                    :: .PathExprSegments
                                    )
                                    ( self . #token("return_type", "Identifier"), .CallParamsList )
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

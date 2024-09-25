```k

module MX-RUST-PREPROCESSING-PROXY
    imports COMMON-K-CELL
    imports MX-RUST-REPRESENTATION
    imports RUST-PREPROCESSING-CONFIGURATION

    rule
        <k>
            rustMxAddProxyMethods(Trait:TypePath)
            => error
                ( "execute_on_dest_context already exists for trait"
                , ListItem(Trait)
                )
            ...
        </k>
        <trait-path> Trait </trait-path>
        <method-name> #token("execute_on_dest_context", "Identifier") </method-name>
        [priority(50)]

    rule
        <k>
            rustMxAddProxyMethods(Trait:TypePath)
            => .K
            ...
        </k>
        <trait-path> Trait </trait-path>
        ( .Bag
            =>  <method>
                    <method-name> #token("execute_on_dest_context", "Identifier") </method-name>
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

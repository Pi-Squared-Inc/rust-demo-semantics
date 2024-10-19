```k

module UKM-PREPROCESSING-METHODS
    imports private COMMON-K-CELL
    imports private K-EQUAL-SYNTAX
    imports private RUST-CONVERSIONS-SYNTAX
    imports private RUST-PREPROCESSING-CONFIGURATION
    imports private UKM-PREPROCESSING-CONFIGURATION
    imports private UKM-PREPROCESSING-SYNTAX-PRIVATE
    imports private UKM-ENCODING-SYNTAX

    rule <k>
            ukmPreprocessMethodSignature(Method) => ukmPreprocessingStoreMethodSignature(encodeFunctionSignature(Method, L), Method) 
            ...
        </k>
        <method-name> Method </method-name>
        <method-params> L:NormalizedFunctionParameterList </method-params>

    rule <k> ukmPreprocessingStoreMethodSignature(B:Bytes, P:PathInExpression) => .K ... </k> 
        <ukm-method-hash-to-signatures>
            STATE => STATE [ B <- P ]
        </ukm-method-hash-to-signatures>


    rule ukmPreprocessMethods(_:TypePath, .List) => .K
    rule ukmPreprocessMethods(Trait:TypePath, ListItem(Name:Identifier) Methods:List)
        => ukmPreprocessMethod(Trait, Name, typePathToPathInExpression(append(Trait, Name)))
            ~> ukmPreprocessMethods(Trait, Methods:List)

    rule
        <k>
            ukmPreprocessMethod(Trait:TypePath, MethodIdentifier:Identifier, Method:PathInExpression)
            => ukmPreprocessEndpoint
                (... trait: Trait
                , method: MethodIdentifier
                , fullMethodPath: Method
                , endpointName: getEndpointName(Atts, MethodIdentifier)
                ) ~> ukmPreprocessMethodSignature(Method)
            ...
        </k>
        <method-name> Method </method-name>
        <method-outer-attributes> Atts:OuterAttributes </method-outer-attributes>
        requires getEndpointName(Atts, MethodIdentifier) =/=K ""
        [priority(50)]
    rule ukmPreprocessMethod(_:TypePath, _:Identifier, _:PathInExpression) => .K
        [owise]

    // This is identical to the function in the mx-rust semantics.
    syntax String ::= getEndpointName(atts:OuterAttributes, default:Identifier)  [function, total]
    rule getEndpointName(, _:Identifier) => ""
    rule getEndpointName(.NonEmptyOuterAttributes, _:Identifier) => ""
    rule getEndpointName
            (   (#[ #token("init", "Identifier") :: .SimplePathList
                ])
                _:NonEmptyOuterAttributes
            , _:Identifier
            ) => "#init"
    rule getEndpointName
            (   (#[ #token("upgrade", "Identifier") :: .SimplePathList
                ])
                _:NonEmptyOuterAttributes
            , _:Identifier
            ) => "#upgrade"
    rule getEndpointName
            (   (#[ #token("endpoint", "Identifier") :: .SimplePathList
                    ( Name:Identifier :: .PathExprSegments, .CallParamsList )
                ])
                _:NonEmptyOuterAttributes
            , _:Identifier
            ) => IdentifierToString(Name)
    rule getEndpointName
            (   (#[ #token("view", "Identifier") :: .SimplePathList
                    ( Name:Identifier :: .PathExprSegments, .CallParamsList )
                ])
                _:NonEmptyOuterAttributes
            , _:Identifier
            ) => IdentifierToString(Name)
    rule getEndpointName(_:OuterAttribute Atts:NonEmptyOuterAttributes, Default:Identifier)
        => getEndpointName(Atts, Default)
        [owise]

endmodule

```

```k

module UKM-PREPROCESSING-METHODS
    imports private COMMON-K-CELL
    imports private K-EQUAL-SYNTAX
    imports private RUST-CONVERSIONS-SYNTAX
    imports private RUST-PREPROCESSING-CONFIGURATION
    imports private UKM-PREPROCESSING-CONFIGURATION
    imports private UKM-PREPROCESSING-SYNTAX-PRIVATE

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
                )
            ...
        </k>
        <method-name> Method </method-name>
        <method-outer-attributes> Atts:OuterAttributes </method-outer-attributes>
        requires getEndpointName(Atts, MethodIdentifier) =/=K ""
            andBool getStorageName(Atts) ==K ""
            andBool getEventName(Atts) ==K ""
    rule
        <k>
            ukmPreprocessMethod(_Trait:TypePath, MethodIdentifier:Identifier, Method:PathInExpression)
            => ukmPreprocessStorage
                (... fullMethodPath: Method
                , storageName: getStorageName(Atts)
                )
            ...
        </k>
        <method-name> Method </method-name>
        <method-outer-attributes> Atts:OuterAttributes </method-outer-attributes>
        requires getStorageName(Atts) =/=K ""
            andBool getEndpointName(Atts, MethodIdentifier) ==K ""
            andBool getEventName(Atts) ==K ""
    rule
        <k>
            ukmPreprocessMethod(_Trait:TypePath, MethodIdentifier:Identifier, Method:PathInExpression)
            => ukmPreprocessEvent
                (... fullMethodPath: Method
                , eventName: getEventName(Atts)
                )
            ...
        </k>
        <method-name> Method </method-name>
        <method-outer-attributes> Atts:OuterAttributes </method-outer-attributes>
        requires getEventName(Atts) =/=K ""
            andBool getEndpointName(Atts, MethodIdentifier) ==K ""
            andBool getStorageName(Atts) ==K ""
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

    // This is identical to the function in the mx-rust semantics.
    syntax String ::= getStorageName(atts:OuterAttributes)  [function, total]
    rule getStorageName() => ""
    rule getStorageName(.NonEmptyOuterAttributes) => ""
    rule getStorageName
            (   (#[ #token("storage_mapper", "Identifier") :: .SimplePathList
                    ( Name:String, .CallParamsList )
                ])
                _:NonEmptyOuterAttributes
            ) => Name
    rule getStorageName(_:OuterAttribute Atts:NonEmptyOuterAttributes)
        => getStorageName(Atts)
        [owise]

    syntax String ::= getEventName(atts:OuterAttributes)  [function, total]
    rule getEventName() => ""
    rule getEventName(.NonEmptyOuterAttributes) => ""
    rule getEventName
            (   (#[ #token("event", "Identifier") :: .SimplePathList
                    ( Name:String, .CallParamsList )
                ])
                _:NonEmptyOuterAttributes
            ) => Name
    rule getEventName(_:OuterAttribute Atts:NonEmptyOuterAttributes)
        => getEventName(Atts)
        [owise]
endmodule

```

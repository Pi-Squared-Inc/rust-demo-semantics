```k

module ULM-PREPROCESSING-METHODS
    imports private COMMON-K-CELL
    imports private K-EQUAL-SYNTAX
    imports private RUST-CONVERSIONS-SYNTAX
    imports private RUST-PREPROCESSING-CONFIGURATION
    imports private ULM-PREPROCESSING-SYNTAX-PRIVATE

    rule ulmPreprocessMethods(_:TypePath, .List) => .K
    rule ulmPreprocessMethods(Trait:TypePath, ListItem(Name:Identifier) Methods:List)
        => ulmPreprocessMethod(Trait, Name, typePathToPathInExpression(append(Trait, Name)))
            ~> ulmPreprocessMethods(Trait, Methods:List)

    rule
        <k>
            ulmPreprocessMethod(Trait:TypePath, MethodIdentifier:Identifier, Method:PathInExpression)
            => ulmPreprocessEndpoint
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
            ulmPreprocessMethod(_Trait:TypePath, MethodIdentifier:Identifier, Method:PathInExpression)
            => ulmPreprocessStorage
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
            ulmPreprocessMethod(_Trait:TypePath, MethodIdentifier:Identifier, Method:PathInExpression)
            => ulmPreprocessEvent
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
    rule ulmPreprocessMethod(_:TypePath, _:Identifier, _:PathInExpression) => .K
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

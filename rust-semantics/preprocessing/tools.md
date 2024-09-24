```k

module RUST-PREPROCESSING-TOOLS
    imports private BOOL
    imports private RUST-ERROR-SYNTAX
    imports private RUST-REPRESENTATION
    imports private RUST-SHARED-SYNTAX
    imports private RUST-VALUE-SYNTAX

    rule isValueWithPtr(_) => false  [owise]
    rule isValueWithPtr(_:PtrValue) => true
    rule isValueWithPtr(.CallParamsList) => true
    rule isValueWithPtr(P:Expression , Ps:CallParamsList) => isValueWithPtr(P) andBool isValueWithPtr(Ps)

    rule reverse(.CallParamsList, L:CallParamsList) => L
    rule reverse((P , Ps:CallParamsList => Ps), (L:CallParamsList => P, L))

    rule parentTypePath(:: T:TypePathSegments) => doubleColonOrError(parentTypePathSegments(T))
    rule parentTypePath(T:TypePathSegments) => injectOrError(parentTypePathSegments(T))
    rule parentTypePath(A)
        => error("This should not happen (parentTypePath), the other rules should cover all cases", ListItem(A))
        [owise]

    syntax TypePathSegmentsOrError ::= parentTypePathSegments(TypePathSegments)  [function, total]

    rule parentTypePathSegments(S:TypePathSegment) => error("Path without parent", ListItem(S))
    rule parentTypePathSegments(S:TypePathSegment :: _:TypePathSegment)
        => S
    rule parentTypePathSegments
            ( S:TypePathSegment
            :: ((_:TypePathSegment :: _:TypePathSegments) #as T:TypePathSegments)
            )
        => concat(S, parentTypePathSegments(T))


    rule leafTypePath((:: T:TypePathSegments) => T)
    rule leafTypePath((_:TypePathSegment :: T:TypePathSegments) => T)

    rule leafTypePath((S:PathIdentSegment _:TypePathSegmentSuffix) => S)
    rule leafTypePath(S:Identifier) => S
    rule leafTypePath(S:PathIdentSegment) => error("Unknown segment", ListItem(S))
        [priority(100)]
    rule leafTypePath(A)
        => error("This should not happen (leafTypePath), the other rules should cover all cases", ListItem(A))
        [owise]
endmodule

```
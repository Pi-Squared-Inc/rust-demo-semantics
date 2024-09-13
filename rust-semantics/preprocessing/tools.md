```k

module RUST-PREPROCESSING-TOOLS
    imports private BOOL
    imports private RUST-PREPROCESSING-PRIVATE-SYNTAX
    imports private RUST-REPRESENTATION
    imports private RUST-SHARED-SYNTAX
    imports private RUST-VALUE-SYNTAX

    rule isValueWithPtr(_) => false  [owise]
    rule isValueWithPtr(_:PtrValue) => true
    rule isValueWithPtr(.CallParamsList) => true
    rule isValueWithPtr(P:Expression , Ps:CallParamsList) => isValueWithPtr(P) andBool isValueWithPtr(Ps)

    rule reverse(.CallParamsList, L:CallParamsList) => L
    rule reverse((P , Ps:CallParamsList => Ps), (L:CallParamsList => P, L))

    rule append(.TypePath, Name:Identifier) => Name
    rule append(:: T:TypePathSegments, Name:Identifier) => :: appendSegments(T, Name)
    rule append(T:TypePathSegments, Name:Identifier) => appendSegments(T, Name)

    rule appendSegments(S:TypePathSegment, Name:Identifier) => S :: Name
    rule appendSegments(S:TypePathSegment :: T:TypePathSegments, Name:Identifier)
        => S :: appendSegments(T, Name)

    syntax TypePathSegments ::= appendSegments(TypePathSegments, Identifier)  [function, total]
endmodule

```
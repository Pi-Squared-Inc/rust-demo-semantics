```k

module RUST-EXPRESSION-TOOLS
    imports private BOOL
    imports private RUST-REPRESENTATION
    imports private RUST-SHARED-SYNTAX
    imports private RUST-VALUE-SYNTAX

    rule isValueWithPtr(_) => false  [owise]
    rule isValueWithPtr(_:PtrValue) => true
    rule isValueWithPtr(.CallParamsList) => true
    rule isValueWithPtr(P:Expression , Ps:CallParamsList) => isValueWithPtr(P) andBool isValueWithPtr(Ps)
endmodule

```
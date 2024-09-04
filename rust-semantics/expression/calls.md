```k

module RUST-EXPRESSION-CALLS
    imports private COMMON-K-CELL
    imports private RUST-SHARED-SYNTAX
    imports private RUST-EXECUTION-CONFIGURATION
    imports private RUST-EXPRESSION-TOOLS
    imports private RUST-REPRESENTATION
    imports private RUST-SHARED-SYNTAX

    syntax Instruction ::= methodCall
                ( traitName: TypePath
                , method: Identifier
                , params: CallParamsList
                , reversedNormalizedParams: NormalizedCallParams
                )

    syntax NormalizedCallParams ::= reverse(NormalizedCallParams, NormalizedCallParams)  [function, total]
    rule reverse(.NormalizedCallParams, R:NormalizedCallParams) => R
    rule reverse((P, Ps:NormalizedCallParams), R:NormalizedCallParams) => reverse(Ps, (P, R))

    rule SelfName:Expression . MethodName:Identifier ( )
        => methodCall(... self: SelfName, method: MethodName, params: .CallParamsList)
    rule SelfName:Expression . MethodName:Identifier ( Args:CallParamsList )
        => methodCall(... self: SelfName, method: MethodName, params: Args)
    rule SelfName:Expression . MethodName:Identifier ( Args:CallParamsList, )
        => methodCall(... self: SelfName, method: MethodName, params: Args)

    rule
        <k>
            methodCall
                (... self: ptrValue(ptr(A) #as P, _)
                , method: MethodName:Identifier
                , params: Args:CallParamsList
                )
            => methodCall
                (... traitName: TraitName
                , method: MethodName
                , params: Args
                , reversedNormalizedParams: P, .NormalizedCallParams
                )
            ...
        </k>
        <values> A |-> struct(TraitName:TypePath, _) ... </values>
        requires isValueWithPtr(Args)

    // TODO: Test for this.
    rule methodCall
            (... traitName: _TraitName:TypePath
            , method: _MethodName:Identifier
            , params: (ptrValue(ptr(_) #as P:Ptr, _:Value) , Cps:CallParamsList) => Cps
            , reversedNormalizedParams: Args:NormalizedCallParams
                => P, Args
            )
    rule
        <k>
            methodCall
                (... traitName: _TraitName:TypePath
                , method: _MethodName:Identifier
                , params: (ptrValue(null, V:Value) , Cps:CallParamsList) => Cps
                , reversedNormalizedParams: Args:NormalizedCallParams
                    => ptr(NextId), Args
                )
            ...
        </k>
        <next-value-id> NextId:Int => NextId +Int 1 </next-value-id>
        <values> Values:Map => Values[NextId <- V] </values>
    rule
        methodCall
            (... traitName: TraitName:TypePath
            , method: MethodName:Identifier
            , params: .CallParamsList
            , reversedNormalizedParams: Args:NormalizedCallParams
            )
        => normalizedMethodCall
            ( TraitName
            , MethodName
            , reverse(Args, .NormalizedCallParams)
            )

    // Apparently contexts need the type of the HOLE to be K, and I'm not sure
    // how to transform CallParamsList in some sort of K combination in a
    // reasonable way. We're using heat/cool rules instead.
    rule (.K => HOLE) ~> HOLE:Expression , _:CallParamsList
        [heat, result(ValueWithPtr)]
    rule (HOLE:Expression ~> (_:Expression , L:CallParamsList):CallParamsList)
            => HOLE , L
        [cool, result(ValueWithPtr)]
    rule (.K => HOLE) ~> V:Expression , HOLE:CallParamsList
        requires isValueWithPtr(V)
        [heat, result(ValueWithPtr)]
    rule (HOLE:CallParamsList ~> V:Expression , _:CallParamsList)
        => V , HOLE
        requires isValueWithPtr(V)
        [cool, result(ValueWithPtr)]
endmodule

```

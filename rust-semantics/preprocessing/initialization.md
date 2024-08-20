```k

module INITIALIZATION
    imports private RUST-RUNNING-CONFIGURATION
    imports private RUST-PREPROCESSING-PRIVATE-HELPERS
    imports private RUST-PREPROCESSING-PRIVATE-SYNTAX

    // rule
    //     <k> crateInitializer
    //         ( ... constantNames:(ListItem(Name:Identifier) => .List) _Cts:List
    //         , constants: _Constants (Name |-> V:Value => .Map)
    //         )
    //         ...
    //     </k>
    //     <crate>
    //       <constants>
    //         .Bag =>
    //           <constant>
    //             <constant-name> Name:Identifier </constant-name>
    //             <constant-value> V:Value </constant-value>
    //           </constant>
    //       </constants>
    //       ...
    //     </crate>
    rule constantInitializer(... constantNames : .List) => .K

    rule (.K => addMethod(TraitName, F, A))
          ~> traitMethodInitializer
              ( ... traitName : TraitName:TypePath
              , functionNames: (ListItem(Name:Identifier) => .List) _Names:List
              , functions: _Functions:Map
                ((Name |-> (A:OuterAttributes F:Function):AssociatedItem) => .Map)
              )
    rule traitMethodInitializer(... functionNames: .List) => .K

    rule
        <k> traitInitializer(Name:TypePath) => .K
            ...
        </k>
        <traits>
            ...
            .Bag
            =>  <trait>
                    <trait-path> Name </trait-path>
                    <methods> .Bag </methods>
                </trait>
        </traits>

    // rule addMethod(_Q:FunctionQualifiers F:FunctionWithoutQualifiers, A:OuterAttributes)
    //     => addMethod(F:FunctionWithoutQualifiers, A)
    rule addMethod(Trait:TypePath, (F:FunctionWithWhere B:BlockExpressionOrSemicolon):FunctionWithoutQualifiers, A:OuterAttributes)
        => addMethod1(Trait, F, B, A)

    // rule addMethod1(F:FunctionWithReturnType _W:WhereClause, B:BlockExpressionOrSemicolon, A:OuterAttributes)
    //     => addMethod1(F, B, A)
    // rule addMethod1(F:FunctionWithParams -> RT:Type, B:BlockExpressionOrSemicolon, A:OuterAttributes)
    //     => addMethod2(F, RT, B, A)
    rule addMethod1(Trait:TypePath, F:FunctionWithParams, B:BlockExpressionOrSemicolon, A:OuterAttributes)
        => addMethod2(Trait, F, (), B, A)

    // rule addMethod2(fn Name ( ), T:Type, B:BlockExpressionOrSemicolon, A:OuterAttributes)
    //     => addMethod4(Name, .NormalizedFunctionParameterList, T, B, A)
    rule addMethod2(Trait:TypePath, fn Name (_:SelfParam), T:Type, B:BlockExpressionOrSemicolon, A:OuterAttributes)
        => addMethod4(Trait, Name, (self : $selftype), T, B, A)
    // rule addMethod2(fn Name (_:SelfParam , ), T:Type, B:BlockExpressionOrSemicolon, A:OuterAttributes)
    //     => addMethod4(Name, (self : $selftype), T, B, A)
    // rule addMethod2(fn Name (_:SelfParam , P:FunctionParameterList), T:Type, B:BlockExpressionOrSemicolon, A:OuterAttributes)
    //     => addMethod3(Name, (self : $selftype), P, T, B, A)
    // rule addMethod2(fn Name (_:SelfParam , P:FunctionParameterList ,), T:Type, B:BlockExpressionOrSemicolon, A:OuterAttributes)
    //     => addMethod3(Name, (self : $selftype) , P, T, B, A)

    // rule addMethod3(
    //         _MethodName:Identifier,
    //         ReversedNormalizedParams:NormalizedFunctionParameterList
    //             => (ParamName : ParamType , ReversedNormalizedParams),
    //         (ParamName:Identifier : ParamType:Type , Params:FunctionParameterList)
    //             => Params,
    //         _MethodReturnType:Type, _B:BlockExpressionOrSemicolon, _A:OuterAttributes
    //     )
    // rule addMethod3(
    //         MethodName:Identifier,
    //         ReversedNormalizedParams:NormalizedFunctionParameterList,
    //         .FunctionParameterList,
    //         MethodReturnType:Type, B:BlockExpressionOrSemicolon, A:OuterAttributes
    //     )
    //     => addMethod4(
    //         MethodName,
    //         reverse(ReversedNormalizedParams),
    //         MethodReturnType, B, A
    //     )

    rule
        <k> addMethod4(
                Trait:TypePath,
                Name:Identifier, P:NormalizedFunctionParameterList,
                R:Type, B:BlockExpression,
                _A:OuterAttributes
            ) => .K
            ...
        </k>
        <trait>
          ...
          <trait-path> Trait </trait-path>
          <methods>
            .Bag =>
              <method>
                <method-name> Name:Identifier </method-name>
                <method-params> P </method-params>
                <method-return-type> R </method-return-type>
                <method-implementation> block(B) </method-implementation>
              </method>
            ...
          </methods>
        </trait>

endmodule

```

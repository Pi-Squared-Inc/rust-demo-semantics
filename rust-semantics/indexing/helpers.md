```k

module RUST-INDEXING-PRIVATE-HELPERS
    imports private RUST-REPRESENTATION
    imports RUST-SHARED-SYNTAX

    syntax Identifier ::= getFunctionName(Function)  [function, total]
    rule getFunctionName(_Q:FunctionQualifiers F:FunctionWithoutQualifiers)
        => getFunctionName(F)
    rule getFunctionName(F:FunctionWithWhere _B:BlockExpression)
        => getFunctionName(F ;)
    rule getFunctionName(F:FunctionWithReturnType _W:WhereClause ;)
        => getFunctionName(F ;)
    rule getFunctionName(F:FunctionWithParams _R:FunctionReturnType ;)
        => getFunctionName(F ;)
    rule getFunctionName(fn Name:Identifier _P:GenericParams ( ) ;)
      => Name
    rule getFunctionName(fn Name:Identifier ( ) ;)
        => Name
    rule getFunctionName(fn Name:Identifier  _P:GenericParams ( _Params:FunctionParameters ) ;)
        => Name
    rule getFunctionName(fn Name:Identifier ( _Params:FunctionParameters ) ;)
        => Name

    syntax NormalizedFunctionParameterList  ::= reverse(NormalizedFunctionParameterList)  [function, total]
                                              // See https://github.com/runtimeverification/k/issues/4587
                                              // for the "Non exhaustive match detected" warning
                                              | #reverse(NormalizedFunctionParameterList, NormalizedFunctionParameterList)  [function, total]
    rule reverse(L:NormalizedFunctionParameterList) => #reverse(L, .NormalizedFunctionParameterList)
    rule #reverse(.NormalizedFunctionParameterList, R) => R
    rule #reverse((P:NormalizedFunctionParameter , L:NormalizedFunctionParameterList), R)
        => #reverse(L, (P , R))
endmodule

```

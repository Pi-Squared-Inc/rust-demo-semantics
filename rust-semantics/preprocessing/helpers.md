```k

module RUST-PREPROCESSING-PRIVATE-HELPERS
    imports private RUST-PREPROCESSING-PRIVATE-SYNTAX
    imports private RUST-REPRESENTATION
    imports RUST-SHARED-SYNTAX

    syntax FunctionWithParams ::= getFunctionWithParams(Function)  [function, total]
    rule getFunctionWithParams(_Q:FunctionQualifiers F:FunctionWithoutQualifiers)
        => getFunctionWithParams(F)
    rule getFunctionWithParams(F:FunctionWithWhere _B:BlockExpression)
        => getFunctionWithParams(F ;)
    rule getFunctionWithParams(F:FunctionWithReturnType _W:WhereClause ;)
        => getFunctionWithParams(F ;)
    rule getFunctionWithParams(F:FunctionWithParams _R:FunctionReturnType ;)
        => F
    rule getFunctionWithParams(F:FunctionWithParams ;)
        => F

    syntax Identifier ::= getFunctionWithParamsName(FunctionWithParams)  [function, total]
    rule getFunctionWithParamsName(fn Name:Identifier _P:GenericParams ( ))
        => Name
    rule getFunctionWithParamsName(fn Name:Identifier ( ))
        => Name
    rule getFunctionWithParamsName(fn Name:Identifier  _P:GenericParams ( _Params:FunctionParameters ))
        => Name
    rule getFunctionWithParamsName(fn Name:Identifier ( _Params:FunctionParameters ))
        => Name

    syntax Identifier ::= getFunctionName(Function)  [function, total]
    rule getFunctionName(F:Function)
        => getFunctionWithParamsName(getFunctionWithParams(F))

    syntax NormalizedFunctionParameterListOrError ::= extractFunctionNormalizedParams(Function)  [function, total]
    rule extractFunctionNormalizedParams(F) => extractFunctionWithParamsNormalizedParams(getFunctionWithParams(F))

    syntax NormalizedFunctionParameterListOrError ::= extractFunctionWithParamsNormalizedParams(FunctionWithParams)  [function, total]
    rule extractFunctionWithParamsNormalizedParams(fn _Name:Identifier _P:GenericParams ( ))
        => .NormalizedFunctionParameterList
    rule extractFunctionWithParamsNormalizedParams(fn _Name:Identifier ( ))
        => .NormalizedFunctionParameterList
    rule extractFunctionWithParamsNormalizedParams(fn _Name:Identifier  _P:GenericParams ( Params:FunctionParameters ))
        => normalizeParams(Params)
    rule extractFunctionWithParamsNormalizedParams(fn _Name:Identifier ( Params:FunctionParameters ))
        => normalizeParams(Params)

    syntax NormalizedFunctionParameterListOrError ::= concat(
            NormalizedFunctionParameterOrError,
            NormalizedFunctionParameterListOrError
        )  [function, total]
    rule concat(P:NormalizedFunctionParameter, L:NormalizedFunctionParameterList) => P , L
    rule concat(P:SemanticsError, _:NormalizedFunctionParameterListOrError) => P
    rule concat(_:NormalizedFunctionParameter, L:SemanticsError) => L

    syntax NormalizedFunctionParameterListOrError ::= normalizeParams(FunctionParameters)  [function, total]
    // We should not need an explicit conactenation here, but the LLVM decision tree code crashes.
    rule normalizeParams(_:SelfParam) => self : $selftype , .NormalizedFunctionParameterList
    // We should not need an explicit conactenation here, but the LLVM decision tree code crashes.
    rule normalizeParams(_:SelfParam , ) => self : $selftype , .NormalizedFunctionParameterList
    rule normalizeParams(_:SelfParam , F:FunctionParameterList) => concat(self : $selftype, normalizeParams(F))
    rule normalizeParams(_:SelfParam , F:FunctionParameterList , ) => concat(self : $selftype, normalizeParams(F))
    rule normalizeParams(F:FunctionParameterList ,) => normalizeParams(F)
    rule normalizeParams(.FunctionParameterList) => .NormalizedFunctionParameterList
    rule normalizeParams(P:FunctionParam , F:FunctionParameterList) => concat(normalizeParam(P), normalizeParams(F))

    syntax NormalizedFunctionParameterOrError ::= NormalizedFunctionParameter | SemanticsError

    syntax NormalizedFunctionParameterOrError ::= normalizeParam(FunctionParam)  [function, total]
    rule normalizeParam(_:OuterAttributes Name:Identifier : T:Type) => Name : T
    rule normalizeParam(P:FunctionParam) => error("unimplemented normalizedParam case", P:FunctionParam:KItem)

    syntax BlockExpressionOrSemicolon ::= getFunctionBlockOrSemicolon(Function)  [function, total]
    rule getFunctionBlockOrSemicolon(_Q:FunctionQualifiers F:FunctionWithoutQualifiers)
        => getFunctionBlockOrSemicolon(F)
    rule getFunctionBlockOrSemicolon(_F:FunctionWithWhere B:BlockExpressionOrSemicolon)
        => B

    syntax Type ::= getFunctionReturnType(Function)
    rule getFunctionReturnType(_Q:FunctionQualifiers F:FunctionWithoutQualifiers)
        => getFunctionReturnType(F)
    rule getFunctionReturnType(F:FunctionWithWhere _B:BlockExpression)
        => getFunctionReturnType(F ;)
    rule getFunctionReturnType(F:FunctionWithReturnType _W:WhereClause ;)
        => getFunctionReturnType(F ;)
    rule getFunctionReturnType(_F:FunctionWithParams -> R:Type ;)
        => R
    // https://doc.rust-lang.org/stable/reference/items/functions.html
    // If the output type is not explicitly stated, it is the unit type.
    rule getFunctionReturnType(_F:FunctionWithParams ;)
        => ( ):Type

endmodule

```

Partial Rust Syntax
===================

Macros create ambiguities, so this syntax would be cleaner if it could rely on
macros being already expanded. However, expanding macros on MultiversX code
would force us to support more Rust features in the main semantics.

```k
module RUST-COMMON-SYNTAX
    imports RUST-SHARED-SYNTAX

    syntax Underscore ::= "_"  [token]

```

  https://doc.rust-lang.org/reference/identifiers.html

```k

  // TODO: Not implemented properly
  syntax Identifier ::= r"[A-Za-z_][A-Za-z0-9\\_]*"  [token]
endmodule

module RUST-SHARED-SYNTAX
  imports STRING-SYNTAX
  imports BOOL-SYNTAX
```

  https://doc.rust-lang.org/reference/crates-and-source-files.html

```k
    syntax Crate ::= InnerAttributes Items  [symbol(crate)]
    syntax InnerAttributes ::= List{InnerAttribute, ""}  [symbol(innerAttributes)]
    syntax Items ::= List{Item, ""}  [symbol(items)]

```

  https://doc.rust-lang.org/reference/attributes.html

```k

    syntax InnerAttribute ::= "#![" Attr "]"  [symbol(innerAttribute)]
    syntax OuterAttribute ::= "#[" Attr "]"  [symbol(outerAttribute)]

    syntax Attr ::= SimplePath
                  | SimplePath AttrInput
    syntax AttrInput ::= DelimTokenTree | "=" Expression

```

  https://doc.rust-lang.org/reference/items.html

```k

  syntax Item ::= OuterAttributes VisOrMacroItem  [symbol(item)]
  syntax NonEmptyOuterAttributes ::= NeList{OuterAttribute, ""}
  syntax OuterAttributes  ::= ""  [symbol("emptyOuterAttributes")]
                            | NonEmptyOuterAttributes
  syntax VisOrMacroItem ::= VisItem | MacroItem
  syntax MacroItem ::= MacroInvocationSemi | MacroRulesDefinition
  syntax VisItem ::= MaybeVisibility VisItemItem
  syntax MaybeVisibility ::= "" | Visibility
  syntax VisItemItem  ::= Module
                        | ExternCrate
                        | UseDeclaration
                        | Function
                        | TypeAlias
                        | Struct
                        | Enumeration
                        | Union
                        | ConstantItem
                        | StaticItem
                        | Trait
                        | Implementation
                        | ExternBlock

```

  https://doc.rust-lang.org/reference/visibility-and-privacy.html

```k

  syntax Visibility  ::= "pub"
                      | "pub" "(" "crate" ")"
                      | "pub" "(" SelfSort ")"
                      | "pub" "(" "super" ")"
                      | "pub" "(" "in" SimplePath ")"

```
  https://doc.rust-lang.org/reference/paths.html#simple-paths
```k

  syntax SimplePath ::= SimplePathList | "::" SimplePathList
  syntax SimplePathList ::= NeList{SimplePathSegment, "::"}
  syntax SimplePathSegment ::= Identifier | "super" | SelfSort | "crate" | "$crate"

```
  https://doc.rust-lang.org/reference/items/modules.html
```k

  syntax Module ::= MaybeUnsafe "mod" Identifier ";"
                  | MaybeUnsafe "mod" Identifier "{" InnerAttributes Items "}"

```
https://doc.rust-lang.org/reference/items/extern-crates.html
```k

  syntax ExternCrate ::= "TODO: not needed yet, not implementing"

```
  https://doc.rust-lang.org/reference/items/use-declarations.html
```k

  syntax UseDeclaration ::= "use" UseTree ";"
  syntax UseTree  ::= "*"
                    | MaybeSimplePathWithColon "*"
                    | "{" MaybeUseTreesMaybeComma "}"
                    | MaybeSimplePathWithColon "{" MaybeUseTreesMaybeComma "}"
                    | SimplePath
                    | SimplePath "as" SimplePathAs
  syntax MaybeSimplePathWithColon ::= "::" | SimplePath "::"
  syntax MaybeUseTreesMaybeComma ::= "" | UseTrees | UseTrees ","
  syntax UseTrees ::= NeList{UseTree, ","}
  syntax MaybeSimplePathAs ::= "" | "as" SimplePathAs
  syntax SimplePathAs ::= Identifier | Underscore

```

  https://doc.rust-lang.org/reference/items/functions.html

```k

  syntax Function ::= FunctionQualifiers FunctionWithoutQualifiers
                    | FunctionWithoutQualifiers
  syntax FunctionWithoutQualifiers ::= FunctionWithWhere
                                        BlockExpressionOrSemicolon
  syntax FunctionWithParams ::= "fn" IdentifierMaybeWithParams
                                "("  ")"
                              |  "fn" IdentifierMaybeWithParams
                                "(" FunctionParameters ")"
  syntax FunctionWithReturnType ::= FunctionWithParams
                                  | FunctionWithParams FunctionReturnType
  syntax FunctionWithWhere ::= FunctionWithReturnType | FunctionWithReturnType WhereClause
  syntax IdentifierMaybeWithParams ::= Identifier | Identifier GenericParams
  syntax BlockExpressionOrSemicolon ::= BlockExpression | ";"

  syntax FunctionQualifiers ::= "TODO: not needed yet, not implementing"

  syntax FunctionParameters ::= SelfParam MaybeComma
                              | MaybeSelfParamWithComma FunctionParameterList MaybeComma
  syntax MaybeComma ::= "" | ","
  syntax MaybeSelfParamWithComma ::= "" | SelfParam ","
  syntax FunctionParameterList ::= NeList{FunctionParam, ","}

  syntax SelfParam ::= OuterAttributes ShorthandOrTypedSelf
  syntax ShorthandOrTypedSelf ::= ShorthandSelf | TypedSelf
  syntax ShorthandSelf ::= MaybeReferenceOrReferenceLifetime MaybeMutable SelfSort
  syntax MaybeReferenceOrReferenceLifetime ::= "" | ReferenceOrReferenceLifetime
  syntax ReferenceOrReferenceLifetime ::= "&" | "&" Lifetime
  syntax MaybeMutable ::= "" | "mut"
  syntax TypedSelf ::= MaybeMutable SelfSort ":" Type
  syntax FunctionParam ::= OuterAttributes FunctionParamDetail
  // TODO: Missing cases
  syntax FunctionParamDetail ::= FunctionParamPattern
  syntax FunctionParamPattern ::= PatternNoTopAlt ":" TypeOrDots
  // TODO: Missing cases
  syntax TypeOrDots ::= Type
  syntax FunctionReturnType ::= "->" Type

```
  https://doc.rust-lang.org/reference/items/type-aliases.html

```k

  syntax TypeAlias ::= "TODO: not needed yet, not implementing"

```
  https://doc.rust-lang.org/reference/items/structs.html

```k

  syntax Struct ::= "TODO: not needed yet, not implementing"

```

  https://doc.rust-lang.org/reference/items/enumerations.html

```k

  syntax Enumeration ::= "TODO: not needed yet, not implementing"

```

  https://doc.rust-lang.org/reference/items/unions.html

```k

  syntax Union ::= "TODO: not needed yet, not implementing"

```

  https://doc.rust-lang.org/reference/items/constant-items.html

```k

  syntax ConstantItem ::= "const" IdentifierOrUnderscore ":" Type "=" Expression ";"  [strict(3)]
                        | "const" IdentifierOrUnderscore ":" Type ";"
  syntax IdentifierOrUnderscore ::= Identifier | Underscore

```

  https://doc.rust-lang.org/reference/items/static-items.html

```k

  syntax StaticItem ::= "TODO: not needed yet, not implementing"

```

  https://doc.rust-lang.org/reference/items/traits.html

```k

  syntax Trait ::= MaybeUnsafe "trait" Identifier MaybeGenericParams
                  MaybeColonMaybeTypeParamBounds MaybeWhereClause "{"
                      InnerAttributes AssociatedItems
                  "}"
  syntax MaybeGenericParams ::= "" | GenericParams
  syntax MaybeWhereClause ::= "" | WhereClause
  syntax MaybeUnsafe ::= "" | "unsafe"
  syntax MaybeColonMaybeTypeParamBounds ::= "" | ":" MaybeTypeParamBounds
  syntax MaybeTypeParamBounds ::= "" | TypeParamBounds
  syntax AssociatedItems ::= List{AssociatedItem, ""}

```

  https://doc.rust-lang.org/reference/items/implementations.html

```k

  syntax Implementation ::= "TODO: not needed yet, not implementing"

```

  https://doc.rust-lang.org/reference/items/external-blocks.html

```k

  syntax ExternBlock ::= "TODO: not needed yet, not implementing"

```

  https://doc.rust-lang.org/reference/expressions/literal-expr.html

```k

  syntax LiteralExpression  ::= CharLiteral | StringLiteral | RawStringLiteral
                              | ByteLiteral | ByteStringLiteral | RawByteStringLiteral
                              | CStringLiteral | RawCStringLiteral
                              | IntegerLiteral | FloatLiteral
                              | Bool

  syntax CharLiteral ::= "TODO: not needed yet, not implementing"
  // TODO: Not implemented properly
  syntax StringLiteral ::= String
  syntax RawStringLiteral ::= "TODO: not needed yet, not implementing"
  syntax ByteLiteral ::= "TODO: not needed yet, not implementing"
  syntax ByteStringLiteral ::= "TODO: not needed yet, not implementing"
  syntax RawByteStringLiteral ::= "TODO: not needed yet, not implementing"
  syntax CStringLiteral ::= "TODO: not needed yet, not implementing"
  syntax RawCStringLiteral ::= "TODO: not needed yet, not implementing"
  // TODO: Not implemented properly
  syntax IntegerLiteral ::= r"[0-9]([0-9]|_)*([a-zA-Z][a-zA-Z0-9_]*)?" [token]
  syntax FloatLiteral ::= "TODO: not needed yet, not implementing"

```

  https://doc.rust-lang.org/reference/trait-bounds.html

```k

  syntax TypeParamBounds ::= "TODO: not needed yet, not implementing"
  syntax Lifetime ::= "TODO: not needed yet, not implementing"

```

  https://doc.rust-lang.org/reference/items/generics.html#where-clauses

```k

  syntax WhereClause ::= "TODO: not needed yet, not implementing"

```

  https://doc.rust-lang.org/reference/expressions.html

  https://doc.rust-lang.org/reference/expressions/operator-expr.html
  https://doc.rust-lang.org/reference/expressions/operator-expr.html#negation-operators
  https://doc.rust-lang.org/reference/expressions/operator-expr.html#arithmetic-and-logical-binary-operators
  https://doc.rust-lang.org/reference/expressions/operator-expr.html#comparison-operators
  https://doc.rust-lang.org/reference/expressions/operator-expr.html#lazy-boolean-operators
  https://doc.rust-lang.org/reference/expressions/operator-expr.html#borrow-operators
  https://doc.rust-lang.org/reference/expressions/operator-expr.html#assignment-expressions
  https://doc.rust-lang.org/reference/expressions/operator-expr.html#compound-assignment-expressions
  https://doc.rust-lang.org/reference/expressions/array-expr.html#array-and-slice-indexing-expressions
  https://doc.rust-lang.org/reference/expressions/field-expr.html
  https://doc.rust-lang.org/reference/expressions/range-expr.html

```k
  // Flattened in order to handle precedence.
  syntax Expression ::= NonEmptyOuterAttributes Expression
                      | ExpressionWithBlock

  syntax Expression ::= LiteralExpression
                      | GroupedExpression
                      | ArrayExpression
                      | AwaitExpression
                      | TupleExpression
                      | TupleIndexingExpression
                      | StructExpression
                      | ClosureExpression
                      | AsyncBlockExpression
                      | ContinueExpression
                      | BreakExpression
                      | UnderscoreExpression

                      | CallExpression
                      | ErrorPropagationExpression
                      | TypeCastExpression
                      // TODO: Removed because it causes ambiguities.
                      // | MacroInvocation

  // Several sub-expressions were included directly in Expression
  // to make it easy to disambiguate based on priority
  syntax Expression ::= PathExpression

                      // https://doc.rust-lang.org/reference/expressions/method-call-expr.html
                      > Expression "." PathExprSegment "(" ")"
                      | Expression "." PathExprSegment "(" CallParams ")"

                      > Expression "." Identifier  // FieldExpression

                      // > CallExpression
                      | Expression "[" Expression "]"

                      // > ErrorPropagationExpression

                      > "&" Expression
                      | "&&" Expression
                      | "&" "mut" Expression
                      | "&&" "mut" Expression
                      | "-" Expression
                      | "!" Expression
                      | DereferenceExpression

                      // > left:
                      //   TypeCastExpression

                      > left:
                        Expression "*" Expression [seqstrict, left]
                      | Expression "/" Expression [seqstrict, left]
                      | Expression "%" Expression [seqstrict, left]

                      > left:
                        Expression "+" Expression [seqstrict, left]
                      | Expression "-" Expression [seqstrict, left]

                      > left:
                        Expression "<<" Expression
                      | Expression ">>" Expression

                      > left:
                        Expression "&" Expression
                      | Expression "^" Expression
                      | Expression "|" Expression

                      > Expression "==" Expression [seqstrict]
                      | Expression "!=" Expression [seqstrict]
                      | Expression ">" Expression [seqstrict]
                      | Expression "<" Expression [seqstrict]
                      | Expression ">=" Expression [seqstrict]
                      | Expression "<=" Expression [seqstrict]

                      > left:
                        Expression "&&" Expression
                      | Expression "||" Expression

                      > Expression ".." Expression

                      > right:
                        Expression "=" Expression
                      | Expression "+=" Expression
                      | Expression "-=" Expression
                      | Expression "*=" Expression
                      | Expression "/=" Expression
                      | Expression "%=" Expression
                      | Expression "&=" Expression
                      | Expression "|=" Expression
                      | Expression "^=" Expression
                      | Expression "<<=" Expression
                      | Expression ">>=" Expression

                      // https://doc.rust-lang.org/reference/expressions/return-expr.html
                      > "return"
                      | "return" Expression


  syntax ExpressionWithBlock  ::= BlockExpression
                                | UnsafeBlockExpression
                                | LoopExpression
                                | IfExpression
                                | IfLetExpression
                                | MatchExpression

```

  https://doc.rust-lang.org/reference/expressions/path-expr.html

```k

  syntax PathExpression ::=  PathInExpression | QualifiedPathInExpression

```

  https://doc.rust-lang.org/reference/paths.html#paths-in-expressions

```k

  syntax PathInExpression ::= PathExprSegments | "::" PathExprSegments
  syntax PathExprSegments ::= NeList{PathExprSegment, "::"}
  syntax PathExprSegment ::= PathIdentSegment | PathIdentSegment "::" GenericArgs
  syntax PathIdentSegment ::= Identifier | "super" | SelfSort | "Self" | "crate" | "$crate"
  syntax GenericArgs ::= "<" ">" | "<" GenericArgList MaybeComma ">"
  syntax GenericArgList ::= NeList{GenericArg, ","}
  // TODO: Not implemented properly
  syntax GenericArg ::= Type

```

  https://doc.rust-lang.org/reference/paths.html#qualified-paths

```k

  syntax QualifiedPathInExpression ::= "TODO: not needed yet, not implementing"
  syntax QualifiedPathInType ::= "TODO: not needed yet, not implementing"

```

  https://doc.rust-lang.org/reference/expressions/operator-expr.html#the-dereference-operator

```k

  syntax DereferenceExpression ::= "TODO: not needed yet, not implementing"

```

  https://doc.rust-lang.org/reference/expressions/operator-expr.html#the-question-mark-operator

```k

  syntax ErrorPropagationExpression ::= "TODO: not needed yet, not implementing"

```

  https://doc.rust-lang.org/reference/expressions/operator-expr.html#type-implicitCast-expressions

```k

  syntax TypeCastExpression ::= "TODO: not needed yet, not implementing"

```

  https://doc.rust-lang.org/reference/expressions/grouped-expr.html

```k

  syntax GroupedExpression ::= "(" Expression ")"

```

  https://doc.rust-lang.org/reference/expressions/array-expr.html

```k

  syntax ArrayExpression ::= "TODO: not needed yet, not implementing"

```

  https://doc.rust-lang.org/reference/expressions/await-expr.html

```k

  syntax AwaitExpression ::= "TODO: not needed yet, not implementing"

```

  https://doc.rust-lang.org/reference/expressions/tuple-expr.html

```k

  syntax TupleExpression ::= "(" MaybeTupleElements ")"
  syntax MaybeTupleElements ::= "" | TupleElements
  syntax TupleElements  ::= Expression ","
                          | Expression "," TupleElementsNoEndComma
                          | Expression "," TupleElementsNoEndComma ","
  syntax TupleElementsNoEndComma ::= NeList{Expression, ","}

```

  https://doc.rust-lang.org/reference/expressions/tuple-expr.html#tuple-indexing-expressions

```k

  syntax TupleIndexingExpression ::= "TODO: not needed yet, not implementing"

```

  https://doc.rust-lang.org/reference/expressions/struct-expr.html

```k

  syntax StructExpression ::= "TODO: not needed yet, not implementing"

```

  https://doc.rust-lang.org/reference/expressions/call-expr.html

```k

  // TODO: Not implemented properly to avoid ambiguities
  syntax CallExpression ::= PathExpression "(" MaybeCallParams ")"
  syntax MaybeCallParams ::= "" | CallParams
  syntax CallParams ::= CallParamsList | CallParamsList ","
  syntax CallParamsList ::= NeList{Expression, ","}

```

  https://doc.rust-lang.org/reference/expressions/closure-expr.html

```k

  syntax ClosureExpression ::= "TODO: not needed yet, not implementing"

```

  https://doc.rust-lang.org/reference/expressions/block-expr.html#async-blocks

```k

  syntax AsyncBlockExpression ::= "TODO: not needed yet, not implementing"

```

  https://doc.rust-lang.org/reference/expressions/loop-expr.html#continue-expressions

```k

  syntax ContinueExpression ::= "TODO: not needed yet, not implementing"

```

  https://doc.rust-lang.org/reference/expressions/loop-expr.html#break-expressions

```k

  syntax BreakExpression ::= "TODO: not needed yet, not implementing"

```

  https://doc.rust-lang.org/reference/expressions/underscore-expr.html

```k

  syntax UnderscoreExpression ::= Underscore

```

  https://doc.rust-lang.org/reference/macros.html#macro-invocation

```k

  syntax MacroInvocation ::= SimplePath "!" DelimTokenTree
  // TODO: Not implemented properly
  syntax DelimTokenTree ::= "(" MaybeCallParams ")"
  // TODO: Not implemented properly
  syntax MacroInvocationSemi ::= MacroInvocation ";"

```

  https://doc.rust-lang.org/reference/macros-by-example.html

```k

  syntax MacroRulesDefinition ::= "TODO: not needed yet, not implementing"

```

  https://doc.rust-lang.org/reference/expressions/block-expr.html

```k

  syntax BlockExpression ::= "{" InnerAttributes MaybeStatements "}"
  syntax MaybeStatements ::= "" | Statements
  syntax Statements ::= NonEmptyStatements
                      // TODO: Not implemented properly
                      | NonEmptyStatements Expression
                      // TODO: Not implemented properly
                      | Expression
  syntax NonEmptyStatements ::= NeList{Statement, ""}

```

  https://doc.rust-lang.org/reference/expressions/block-expr.html#unsafe-blocks

```k

  syntax UnsafeBlockExpression ::= "TODO: not needed yet, not implementing"

```

  https://doc.rust-lang.org/reference/expressions/loop-expr.html

```k

  syntax LoopExpression ::= LoopExpressionDetail | LoopLabel LoopExpressionDetail
  syntax LoopExpressionDetail ::= InfiniteLoopExpression
                                | PredicateLoopExpression
                                | PredicatePatternLoopExpression
                                | IteratorLoopExpression
                                | LabelBlockExpression

```

  https://doc.rust-lang.org/reference/expressions/loop-expr.html#loop-labels

```k

  syntax LoopLabel ::= "TODO: not needed yet, not implementing"

```

  https://doc.rust-lang.org/reference/expressions/loop-expr.html#infinite-loops

```k

  syntax InfiniteLoopExpression ::= "TODO: not needed yet, not implementing"

```

  https://doc.rust-lang.org/reference/expressions/loop-expr.html#predicate-loops

```k

  syntax PredicateLoopExpression ::= "TODO: not needed yet, not implementing"

```

  https://doc.rust-lang.org/reference/expressions/loop-expr.html#predicate-pattern-loops

```k

  syntax PredicatePatternLoopExpression ::= "TODO: not needed yet, not implementing"

```

  https://doc.rust-lang.org/reference/expressions/loop-expr.html#iterator-loops

```k

  syntax IteratorLoopExpression ::= "for" Pattern "in" ExpressionExceptStructExpression BlockExpression

```

  https://doc.rust-lang.org/reference/expressions/loop-expr.html#labelled-block-expressions

```k

  syntax LabelBlockExpression ::= "TODO: not needed yet, not implementing"

```

  https://doc.rust-lang.org/reference/expressions/if-expr.html#if-expressions

```k

  syntax IfExpression ::= "if" ExpressionExceptStructExpression BlockExpression MaybeIfElseExpression
  syntax MaybeIfElseExpression ::= "" | "else" IfElseExpression
  syntax IfElseExpression ::= BlockExpression | IfExpression | IfLetExpression
  // TODO: Not implemented properly
  syntax ExpressionExceptStructExpression ::= Expression

```

  https://doc.rust-lang.org/reference/expressions/if-expr.html#if-let-expressions

```k

  syntax IfLetExpression ::= "TODO: not needed yet, not implementing"

```

  https://doc.rust-lang.org/reference/expressions/match-expr.html

```k

  syntax MatchExpression ::= "TODO: not needed yet, not implementing"

```

  https://doc.rust-lang.org/reference/statements.html

```k

  syntax Statement  ::= ";"
                      // TODO: Item creates ambiguities, should be resolved by
                      // expanding macros before parsing.
                      // | Item
                      | LetStatement
                      | ExpressionStatement
                      | MacroInvocationSemi

```

  https://doc.rust-lang.org/reference/statements.html#let-statements

```k

  syntax LetStatement ::= OuterAttributes "let" PatternNoTopAlt MaybeColonType ";"
                        | OuterAttributes "let" PatternNoTopAlt MaybeColonType "=" Expression MaybeElseBlockExpression ";"  [strict(4)]
  syntax MaybeColonType ::= "" | ":" Type
  // TODO: Not implemented properly to remove ambiguities
  syntax MaybeElseBlockExpression ::= "" // | "else" BlockExpression

```

  https://doc.rust-lang.org/reference/statements.html#expression-statements

```k

  // TODO: Not implemented properly
  syntax ExpressionStatement  ::= Expression ";"
  syntax MaybeSemicolon ::= "" | ";"

```

  https://doc.rust-lang.org/reference/patterns.html

```k

  syntax Pattern ::= PatternNoTopAlts | "|" PatternNoTopAlts
  syntax PatternNoTopAlts ::= NeList{PatternNoTopAlt, "|"}
  syntax PatternNoTopAlt  ::= PatternWithoutRange
                            | RangePattern
  syntax PatternWithoutRange  ::= LiteralPattern
                                | IdentifierPattern
                                | WildcardPattern
                                | RestPattern
                                | ReferencePattern
                                | StructPattern
                                | TupleStructPattern
                                | TuplePattern
                                | GroupedPattern
                                | SlicePattern
                                | PathPattern
                                | MacroInvocation

```

  https://doc.rust-lang.org/reference/patterns.html#range-patterns

```k

  syntax RangePattern ::= "TODO: not needed yet, not implementing"

```

  https://doc.rust-lang.org/reference/patterns.html#literal-patterns

```k

  syntax LiteralPattern ::= "TODO: not needed yet, not implementing"

```

  https://doc.rust-lang.org/reference/patterns.html#identifier-patterns

```k

  syntax IdentifierPattern ::= IdentifierPattern1 | "ref" IdentifierPattern1
  syntax IdentifierPattern1 ::= IdentifierPattern2 | "mut" IdentifierPattern2
  syntax IdentifierPattern2 ::= Identifier | Identifier "@" PatternNoTopAlt

```

  https://doc.rust-lang.org/reference/patterns.html#wildcard-pattern

```k

  syntax WildcardPattern ::= Underscore

```

  https://doc.rust-lang.org/reference/patterns.html#rest-patterns

```k

  syntax RestPattern ::= ".."

```

  https://doc.rust-lang.org/reference/patterns.html#reference-patterns

```k

  syntax ReferencePattern ::= "TODO: not needed yet, not implementing"

```

  https://doc.rust-lang.org/reference/patterns.html#struct-patterns

```k

  syntax StructPattern ::= "TODO: not needed yet, not implementing"

```

  https://doc.rust-lang.org/reference/patterns.html#tuple-struct-patterns

```k

  syntax TupleStructPattern ::= "TODO: not needed yet, not implementing"

```

  https://doc.rust-lang.org/reference/patterns.html#tuple-patterns

```k

  syntax TuplePattern ::= "(" MaybeTuplePatternItems ")"
  syntax MaybeTuplePatternItems ::= "" | TuplePatternItems
  syntax TuplePatternItems ::= Pattern "," | RestPattern | Patterns | Patterns ","
  syntax Patterns ::= NeList{Pattern, ","}

```

  https://doc.rust-lang.org/reference/patterns.html#grouped-patterns

```k

  syntax GroupedPattern ::= "TODO: not needed yet, not implementing"

```

  https://doc.rust-lang.org/reference/patterns.html#slice-patterns

```k

  syntax SlicePattern ::= "TODO: not needed yet, not implementing"

```

  https://doc.rust-lang.org/reference/patterns.html#path-patterns

```k

  syntax PathPattern ::= "TODO: not needed yet, not implementing"

```

  https://doc.rust-lang.org/reference/items/associated-items.html

```k

  syntax AssociatedItem ::= OuterAttributes AssociatedItemDetails
  syntax AssociatedItemDetails ::= MacroInvocationSemi | MaybeVisibility AssociatedItemDetailsDetails
  syntax AssociatedItemDetailsDetails ::= TypeAlias | ConstantItem | Function

```

  https://doc.rust-lang.org/reference/types.html#type-expressions

```k

  syntax Type ::= TypeNoBounds
                | ImplTraitType
                | TraitObjectType
  syntax TypeNoBounds ::= ParenthesizedType
                        | ImplTraitTypeOneBound
                        | TraitObjectTypeOneBound
                        | TypePath
                        | TupleType
                        | NeverType
                        | RawPointerType
                        | ReferenceType
                        | ArrayType
                        | SliceType
                        | InferredType
                        | QualifiedPathInType
                        | BareFunctionType
                        | MacroInvocation
```

  https://doc.rust-lang.org/reference/types/impl-trait.html

```k

  syntax ImplTraitType ::= "TODO: not needed yet, not implementing"
  syntax ImplTraitTypeOneBound ::= "TODO: not needed yet, not implementing"

```

  https://doc.rust-lang.org/reference/types/trait-object.html

```k

  syntax TraitObjectType ::= "TODO: not needed yet, not implementing"
  syntax TraitObjectTypeOneBound ::= "TODO: not needed yet, not implementing"

```

  https://doc.rust-lang.org/reference/types.html#parenthesized-types

```k

  syntax ParenthesizedType ::= "TODO: not needed yet, not implementing"

```

  https://doc.rust-lang.org/reference/paths.html#paths-in-types

```k

  syntax TypePath ::= TypePathSegments
                    | "::" TypePathSegments
  // There is a K bug somewhere which causes an identifier to be either directly
  // injected in Type (Identifier -> PathIdentSegment -> TypePathSegment ->
  // TypePathSegments -> TypePath -> TypeNoBounds -> Type) or to be included
  // through a constructor (concatTypePathSegments(Identifier, .TypePathSegments)).
  // This is really annoying because it does not generate compilation errors,
  // but causes rules to not apply properly.
  //
  // As an example, this means that you can't simply write
  //
  // rule implicitCast(u64(Value), u64) => u64(Value)
  //
  // because that rule will compile just fine, but it will never apply at
  // runtime because it uses an injection (why??? there is no injection
  // available!), while the parser will produce actual TypePathSegments lists
  // (the K rule will also produce lists from `u64` sometimes, I'm not yet sure
  // when). Instead, you need to write
  //
  // rule implicitCast(u64(Value), u64 :: .TypePathSegments) => u64(Value)
  //
  // which will work, but you have to figure out all cases where this may happen
  // without any help from the compiler.
  //
  // FWIW, one way of producing a list in K instead of an injection is to do
  // something like:
  //
  // syntax KItem ::= tmp(TypePathSegments)
  // rule stuff => tmp(u64)
  //
  // I'm not sure why one does not get an injection here (but it switches back
  // to injections when replacing TypePathSegments by Type). This behaviour is
  // inconsistent, and it's a bug to use injections here.
  //
  // I just wanted to say that I think it's better to not use NeList here.
  //
  // syntax TypePathSegments ::= NeList{TypePathSegment, "::"}
  syntax TypePathSegments ::= TypePathSegment | TypePathSegment "::" TypePathSegments
  syntax TypePathSegment ::= PathIdentSegment | PathIdentSegment TypePathSegmentSuffix
  syntax TypePathSegmentSuffix ::= TypePathSegmentSuffixSuffix | "::" TypePathSegmentSuffixSuffix
  // TODO: Not implemented properly
  syntax TypePathSegmentSuffixSuffix ::= GenericArgs

```

  https://doc.rust-lang.org/reference/types/tuple.html#tuple-types

```k

  syntax TupleType  ::= "(" ")"
                      | "(" NonEmptyTypeCsv MaybeComma ")"
  syntax NonEmptyTypeCsv ::= Type | Type "," NonEmptyTypeCsv

```

  https://doc.rust-lang.org/reference/types/never.html

```k

  syntax NeverType ::= "!"

```

  https://doc.rust-lang.org/reference/types/pointer.html#raw-pointers-const-and-mut

```k

  syntax RawPointerType ::= "TODO: not needed yet, not implementing"

```

  https://doc.rust-lang.org/reference/types/array.html

```k

  syntax ArrayType ::= "TODO: not needed yet, not implementing"

```

  https://doc.rust-lang.org/reference/types/slice.html

```k

  syntax SliceType ::= "TODO: not needed yet, not implementing"

```

  https://doc.rust-lang.org/reference/types/inferred.html

```k

  syntax InferredType ::= "TODO: not needed yet, not implementing"

```

  https://doc.rust-lang.org/reference/types/function-pointer.html

```k

  syntax BareFunctionType ::= "TODO: not needed yet, not implementing"

```

  https://doc.rust-lang.org/reference/types/pointer.html#references--and-mut

```k

  syntax ReferenceType ::= "&" MaybeLifetime MaybeMutable TypeNoBounds
  syntax MaybeLifetime ::= "" | Lifetime

```

  https://doc.rust-lang.org/reference/items/generics.html

```k

  syntax GenericParams  ::= "<" ">"
                          | "<" GenericParamList MaybeComma ">"
  syntax GenericParamList ::= NeList{GenericParam, ","}
  // TODO: Not implemented properly
  syntax GenericParam ::= TypeParam
  // TODO: Not implemented properly
  syntax TypeParam ::= Identifier

  syntax SelfSort ::= "self"

  syntax Underscore  [token]
  syntax Identifier  [token]
endmodule
```

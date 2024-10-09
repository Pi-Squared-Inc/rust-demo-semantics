```k

module INITIALIZATION
    imports private COMMON-K-CELL
    imports private RUST-CONVERSIONS-SYNTAX
    imports private RUST-PREPROCESSING-CONFIGURATION
    imports private RUST-PREPROCESSING-PRIVATE-HELPERS
    imports private RUST-PREPROCESSING-PRIVATE-SYNTAX

    rule
        <k> structInitializer( (struct Name:Identifier { F:StructFields } ):Struct, ParentPath:TypePath) => structParser(append(ParentPath, Name), F:StructFields )
            ...
        </k>
        <struct-list> .List => ListItem(append(ParentPath, Name)) ...</struct-list>
        <structs>
            ...
            .Bag
            =>  <struct>
                    <struct-path> append(ParentPath, Name) </struct-path>
                    ...
                </struct>
        </structs>
        
    rule
        <k> structParser(Name:TypePath, ((FN:Identifier : FT:Type):StructField  , RF:StructFields):StructFields) => 
                structParser(Name:TypePath, RF:StructFields)
            ...
        </k>
        <struct>
          ...
          <struct-path> Name </struct-path>
          <field-list> L:List => ListItem(FN) L </field-list>
          <fields>
            .Bag =>
              <field>
                <field-name> FN </field-name>
                <field-type> FT </field-type>
              </field>
            ...
          </fields>
        </struct> 

    rule structParser(_Name:TypePath, .StructFields) => .K

    rule
        <k> traitInitializer(Name:TypePath, Atts:OuterAttributes) => .K
            ...
        </k>
        <trait-list> .List => ListItem(Name) ...</trait-list>
        <traits>
            ...
            .Bag
            =>  <trait>
                    <trait-path> Name </trait-path>
                    <trait-attributes> Atts </trait-attributes>
                    ...
                </trait>
        </traits>

    rule addFunction(Parent:TypePath, F:Function, A:OuterAttributes)
        => #addFunction
            ( Parent
            , getFunctionName(F)
            , extractFunctionNormalizedParams(F)
            , getFunctionReturnType(F)
            , getFunctionBlockOrSemicolon(F)
            , A
            )

    rule addMethod(Trait:TypePath, F:Function, A:OuterAttributes)
        => #addMethod
            ( Trait
            , getFunctionName(F)
            , extractFunctionNormalizedParams(F)
            , getFunctionReturnType(F)
            , getFunctionBlockOrSemicolon(F)
            , A
            )

    rule
        <k> #addMethod(
                Trait:TypePath,
                Name:Identifier, P:NormalizedFunctionParameterList,
                R:Type, B:BlockExpressionOrSemicolon,
                A:OuterAttributes
            )
            => #addFunction(Trait, Name, P, R, B, A)
            ...
        </k>
        <trait>
          ...
          <trait-path> Trait </trait-path>
          <method-list> L:List => ListItem(Name) L </method-list>
        </trait>

    rule
        <k> #addFunction(
                Parent:TypePath,
                Name:Identifier, P:NormalizedFunctionParameterList,
                R:Type, B:BlockExpressionOrSemicolon,
                A:OuterAttributes
            ) => .K
            ...
        </k>
        <methods>
          .Bag =>
            <method>
              <method-name> typePathToPathInExpression(append(Parent, Name)) </method-name>
              <method-params> P </method-params>
              <method-return-type> R </method-return-type>
              <method-implementation> toFBR(B) </method-implementation>
              <method-outer-attributes> A </method-outer-attributes>
            </method>
          ...
        </methods>

    syntax FunctionBodyRepresentation ::= toFBR(BlockExpressionOrSemicolon)  [function, total]
    rule toFBR(B:BlockExpression) => block(B)
    rule toFBR(;) => empty

endmodule

```

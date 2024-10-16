```k

module RUST-PREPROCESSING-CONFIGURATION
    imports private RUST-REPRESENTATION
    imports private RUST-SHARED-SYNTAX

    configuration
        <preprocessed>
            <constants>
                <constant multiplicity="*" type="Map">
                    <constant-name> .PathInExpression </constant-name>
                    <constant-value> tuple(.ValueList) </constant-value>
                </constant>
            </constants>
            <struct-list> .List </struct-list>
            <structs>
                <struct multiplicity="*" type="Map">
                    <struct-path> #token("not#initialized", "Identifier"):Identifier:TypePath </struct-path>
                    <field-list> .List </field-list>  // List of Identifier
                    <fields>
                        <field multiplicity="*" type="Map">
                            <field-name> .Identifier </field-name>
                            <field-type> ():Type </field-type>
                        </field>
                    </fields>
                </struct>
            </structs>
            <trait-list> .List </trait-list>  // List of TypePath
            <traits>
                <trait multiplicity="*" type="Map">
                    <trait-path> #token("not#initialized", "Identifier"):Identifier:TypePath </trait-path>
                    <trait-attributes> `emptyOuterAttributes`(.KList):OuterAttributes </trait-attributes>
                    <method-list> .List </method-list>  // List of Identifier
                </trait>
            </traits>
            <methods>
                <method multiplicity="*" type="Map">
                    <method-name> #token("not#initialized", "Identifier"):Identifier:PathInExpression </method-name>
                    <method-params> .NormalizedFunctionParameterList </method-params>
                    <method-return-type> ():Type </method-return-type>
                    <method-implementation> empty:FunctionBodyRepresentation </method-implementation>
                    <method-outer-attributes> `emptyOuterAttributes`(.KList):OuterAttributes </method-outer-attributes>
                </method>
            </methods>
        </preprocessed>
endmodule

module RUST-PREPROCESSING-METHODS-CONFIGURATION

endmodule

```

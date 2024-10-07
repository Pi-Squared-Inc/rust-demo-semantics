```k

module RUST-PREPROCESSING-CONFIGURATION
    imports private RUST-REPRESENTATION
    imports private RUST-SHARED-SYNTAX

    syntax Identifier ::= "my_identifier"  [token]

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
                    <struct-path> my_identifier:TypePath </struct-path> 
                    <variable-list> .List </variable-list>  // List of Identifier
                    <variables>
                        <variable multiplicity="*" type="Map">
                            <variable-name> .Identifier </variable-name>
                            <variable-type> ():Type </variable-type>
                        </variable>
                    </variables>
                </struct>
            </structs>
            <trait-list> .List </trait-list>  // List of TypePath
            <traits>
                <trait multiplicity="*" type="Map">
                    <trait-path> my_identifier:TypePath </trait-path>
                    <trait-attributes> `emptyOuterAttributes`(.KList):OuterAttributes </trait-attributes>
                    <method-list> .List </method-list>  // List of Identifier
                </trait>
            </traits>
            <methods>
                <method multiplicity="*" type="Map">
                    <method-name> my_identifier:PathInExpression </method-name>
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

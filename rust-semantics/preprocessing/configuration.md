```k

module RUST-PREPROCESSING-CONFIGURATION
    imports private RUST-REPRESENTATION
    imports private RUST-SHARED-SYNTAX

    syntax Identifier ::= "my_identifier"  [token]

    configuration
        <preprocessed>
            <constants>
                <constant multiplicity="*" type="Map">
                    <constant-name> .Identifier </constant-name>
                    <constant-value> tuple(.ValueList) </constant-value>
                </constant>
            </constants>
            <traits>
                <trait multiplicity="*" type="Map">
                    <trait-path> my_identifier:TypePath </trait-path>
                    <method-list> .List </method-list>  // List of Identifier
                    <methods>
                        <method multiplicity="*" type="Map">
                            <method-name> .Identifier </method-name>
                            <method-params> .NormalizedFunctionParameterList </method-params>
                            <method-return-type> ():Type </method-return-type>
                            <method-implementation> empty:FunctionBodyRepresentation </method-implementation>
                            <method-outer-attributes> `emptyOuterAttributes`(.KList):OuterAttributes </method-outer-attributes>
                        </method>
                    </methods>
                </trait>
            </traits>
        </preprocessed>
endmodule


```
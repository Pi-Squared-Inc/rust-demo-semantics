```k

module RUST-PREPROCESSING-CONFIGURATION
    imports private RUST-REPRESENTATION
    imports private RUST-SHARED-SYNTAX

    syntax Identifier ::= "my_identifier"  [token]

    configuration
        <preprocessed>
            <constants>
                <constant multiplicity="*" type="Map">
                    <constant-name> my_identifier </constant-name>
                    <constant-value> tuple(.ValueList) </constant-value>
                </constant>
            </constants>
            <traits>
                <trait multiplicity="*" type="Map">
                    <trait-path> my_identifier:TypePath </trait-path>
                    <methods>
                        <method multiplicity="*" type="Map">
                            <method-name> my_identifier </method-name>
                            <method-params> .NormalizedFunctionParameterList </method-params>
                            <method-return-type> ():Type </method-return-type>
                            <method-implementation> empty:FunctionBodyRepresentation </method-implementation>
                        </method>
                    </methods>
                </trait>
            </traits>
        </preprocessed>
endmodule


```
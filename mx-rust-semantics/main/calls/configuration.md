```k

module MX-RUST-CALLS-CONFIGURATION
    imports LIST
    imports RUST-SHARED-SYNTAX

    configuration
        <mx-rust-calls>
            <rust-execution-state-stack> .List </rust-execution-state-stack>
            <mx-rust-endpoint-to-function> .Map </mx-rust-endpoint-to-function>  // String to Identifier

            // Valid only while a contract call is being prepared
            <mx-rust-last-trait-name> (#token("no#path", "Identifier"):Identifier):TypePath </mx-rust-last-trait-name>
        </mx-rust-calls>
endmodule

```

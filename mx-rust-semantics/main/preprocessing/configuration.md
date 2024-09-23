```k

module MX-RUST-PREPROCESSED-CONFIGURATION
    imports MX-RUST-PREPROCESSED-CONTRACT-TRAIT-CONFIGURATION
    imports MX-RUST-PREPROCESSED-ENDPOINTS-CONFIGURATION

    configuration
        <mx-rust-preprocessed>
            <mx-rust-contract-trait/>
            <mx-rust-endpoint-to-function/>
        </mx-rust-preprocessed>
endmodule

module MX-RUST-PREPROCESSED-CONTRACT-TRAIT-CONFIGURATION
    imports RUST-SHARED-SYNTAX

    configuration
        <mx-rust-contract-trait> (#token("no#path", "Identifier"):Identifier):TypePath </mx-rust-contract-trait>  // String to Identifier
endmodule

module MX-RUST-PREPROCESSED-ENDPOINTS-CONFIGURATION
    imports MAP

    configuration
        <mx-rust-endpoint-to-function> .Map </mx-rust-endpoint-to-function>  // String to Identifier
endmodule
```

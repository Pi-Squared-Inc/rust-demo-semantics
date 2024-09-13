```k

module MX-RUST-PREPROCESSED-CONFIGURATION
    imports MX-RUST-PREPROCESSED-CONTRACT-TRAIT-CONFIGURATION
    imports MX-RUST-PREPROCESSED-ENDPOINTS-CONFIGURATION
    imports MX-RUST-PREPROCESSED-PROXIES-CONFIGURATION

    configuration
        <mx-rust-preprocessed>
            <mx-rust-contract-trait/>
            <mx-rust-endpoint-to-function/>
            <mx-rust-proxies/>
        </mx-rust-preprocessed>
endmodule

module MX-RUST-PREPROCESSED-CONTRACT-TRAIT-CONFIGURATION
    imports RUST-SHARED-SYNTAX

    configuration
        <mx-rust-contract-trait> (#token("no#path", "Identifier"):Identifier):TypePath </mx-rust-contract-trait>  // String to Identifier
endmodule

module MX-RUST-PREPROCESSED-PROXIES-CONFIGURATION
    imports RUST-SHARED-SYNTAX

    configuration
        <mx-rust-proxies>
            <mx-rust-proxy multiplicity="*" type="Map">
                <mx-rust-proxy-module> (#token("no#path", "Identifier"):Identifier):TypePath </mx-rust-proxy-module>
                <mx-rust-proxy-trait> #token("no#path", "Identifier"):Identifier:TypePath </mx-rust-proxy-trait>
            </mx-rust-proxy>
        </mx-rust-proxies>
endmodule

module MX-RUST-PREPROCESSED-ENDPOINTS-CONFIGURATION
    imports MAP

    configuration
        <mx-rust-endpoint-to-function> .Map </mx-rust-endpoint-to-function>  // String to Identifier
endmodule

```

```k

module ULM-PREPROCESSING-CONFIGURATION
    imports RUST-SHARED-SYNTAX

    configuration
        <ulm-preprocessed>
            <ulm-contract-trait>
                (#token("not#initialized", "Identifier"):Identifier):TypePath
            </ulm-contract-trait>
        </ulm-preprocessed>
endmodule

module ULM-PREPROCESSING-EPHEMERAL-CONFIGURATION
    configuration
        <ulm-preprocessing-ephemeral>
            <ulm-endpoint-signatures> .Map </ulm-endpoint-signatures>
        </ulm-preprocessing-ephemeral>
endmodule

```

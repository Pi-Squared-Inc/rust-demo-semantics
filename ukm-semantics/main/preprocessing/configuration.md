```k

module UKM-PREPROCESSING-CONFIGURATION
    imports RUST-SHARED-SYNTAX

    configuration
        <ukm-preprocessed>
            <ukm-contract-trait>
                (#token("not#initialized", "Identifier"):Identifier):TypePath
            </ukm-contract-trait>
        </ukm-preprocessed>
endmodule

module UKM-PREPROCESSING-EPHEMERAL-CONFIGURATION
    configuration
        <ukm-preprocessing-ephemeral>
            <ukm-endpoint-signatures> .Map </ukm-endpoint-signatures>
        </ukm-preprocessing-ephemeral>
endmodule

```

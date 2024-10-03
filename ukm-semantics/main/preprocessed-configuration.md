```k

module UKM-PREPROCESSED-CONFIGURATION
    configuration
        <ukm-preprocessed> .K </ukm-preprocessed>
endmodule

module UKM-FULL-PREPROCESSED-CONFIGURATION
    imports RUST-PREPROCESSING-CONFIGURATION
    imports UKM-PREPROCESSED-CONFIGURATION

    configuration
        <ukm-full-preprocessed>
            <ukm-preprocessed/>
            <preprocessed/>
        </ukm-full-preprocessed>
endmodule

```

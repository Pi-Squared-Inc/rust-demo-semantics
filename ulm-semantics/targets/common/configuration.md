```k

requires "../../main/configuration.md"
requires "../../main/preprocessed-configuration.md"
requires "rust-semantics/config.md"

module ULM-TARGET-COMMON-CONFIGURATION
    imports COMMON-K-CELL
    imports RUST-EXECUTION-CONFIGURATION
    imports ULM-CONFIGURATION
    imports ULM-FULL-PREPROCESSED-CONFIGURATION
    imports ULM-PREPROCESSING-EPHEMERAL-CONFIGURATION

    configuration
        <ulm-preprocessing-ephemeral/>
        <ulm-full-preprocessed/>
        <ulm/>
        <execution/>
        <k/>

endmodule

```

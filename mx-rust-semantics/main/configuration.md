```k

requires "calls/configuration.md"
requires "mx-semantics/main/configuration.md"
requires "preprocessing/configuration.md"
requires "rust-semantics/config.md"

module MX-RUST-COMMON-CONFIGURATION
    imports MX-COMMON-CONFIGURATION
    imports MX-RUST-CALLS-CONFIGURATION
    imports MX-RUST-PREPROCESSED-CONFIGURATION
    imports RUST-CONFIGURATION

    configuration
        <mx-rust>
            <mx-rust-calls/>
            <mx-rust-preprocessed/>
            <mx-common/>
            <rust/>
        </mx-rust>
endmodule

```

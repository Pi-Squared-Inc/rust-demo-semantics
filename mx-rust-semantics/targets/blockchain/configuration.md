```k

requires "../../main/configuration.md"

module COMMON-K-CELL
    configuration
        <k> .K </k>
endmodule

module MX-RUST-CONFIGURATION
    imports COMMON-K-CELL
    imports MX-RUST-COMMON-CONFIGURATION

    configuration
        <mx-rust-cfg>
            <mx-rust/>
            <k/>
        </mx-rust-cfg>
endmodule

```

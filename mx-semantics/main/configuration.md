```k

requires "biguint/configuration.md"
requires "calls/configuration.md"

module MX-COMMON-CONFIGURATION
    imports MX-BIGUINT-CONFIGURATION
    imports MX-CALL-CONFIGURATION

    configuration
        <mx-common>
            <mx-call-data/>
            <mx-biguint/>
        </mx-common>
endmodule

```
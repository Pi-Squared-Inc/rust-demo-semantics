```k

requires "accounts/configuration.md"
requires "biguint/configuration.md"
requires "blocks/configuration.md"
requires "calls/configuration.md"

module MX-COMMON-CONFIGURATION
    imports MX-ACCOUNTS-CONFIGURATION
    imports MX-ACCOUNTS-STACK-CONFIGURATION
    imports MX-BIGUINT-CONFIGURATION
    imports MX-BLOCKS-CONFIGURATION
    imports MX-CALL-CONFIGURATION
    imports MX-CALL-RESULT-CONFIGURATION

    configuration
        <mx-common>
            <mx-call-data/>
            <mx-call-result/>
            <mx-biguint/>
            <mx-blocks/>
            <mx-accounts/>
            <mx-world-stack/>
        </mx-common>
endmodule

```
```k

requires "accounts/configuration.md"
requires "blocks/configuration.md"
requires "call-state/configuration.md"

module MX-COMMON-CONFIGURATION
    imports MX-ACCOUNTS-CONFIGURATION
    imports MX-ACCOUNTS-STACK-CONFIGURATION
    imports MX-BLOCKS-CONFIGURATION
    imports MX-CALL-RESULT-CONFIGURATION
    imports MX-CALL-STATE-CONFIGURATION
    imports MX-CALL-STATE-STACK-CONFIGURATION

    configuration
        <mx-common>
            <mx-call-state/>
            <mx-call-result/>
            <mx-blocks/>
            <mx-accounts/>
            <mx-call-state-stack/>
            <mx-world-stack/>
        </mx-common>
endmodule

```
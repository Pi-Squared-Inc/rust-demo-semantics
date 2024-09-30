```k
requires "../biguint/configuration.md"
requires "../buffers/configuration.md"
requires "../calls/configuration.md"

module MX-CALL-STATE-CONFIGURATION
    imports MX-BIGUINT-CONFIGURATION
    imports MX-BUFFERS-CONFIGURATION
    imports MX-CALL-CONFIGURATION
    imports MX-CALL-RETURN-VALUE-CONFIGURATION

    configuration
        <mx-call-state>
            <mx-call-data/>
            <mx-return-values/>
            <mx-internal-state>
                <mx-biguint/>
                <mx-buffers/>
            </mx-internal-state>
        </mx-call-state>
endmodule

module MX-CALL-STATE-STACK-CONFIGURATION
    imports LIST

    configuration
        <mx-call-state-stack> .List </mx-call-state-stack>
endmodule

```

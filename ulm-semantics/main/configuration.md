```k

requires "hooks/bytes.md"
requires "hooks/state.md"

module ULM-CONFIGURATION
    imports ULM-SEMANTICS-HOOKS-BYTES-CONFIGURATION
    imports ULM-SEMANTICS-HOOKS-STATE-CONFIGURATION
    configuration
        <ulm>
            <ulm-bytes/>
            <ulm-state/>
        </ulm>
endmodule

```
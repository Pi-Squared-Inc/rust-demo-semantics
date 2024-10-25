```k

requires "hooks/bytes.md"
requires "hooks/state.md"

module UKM-CONFIGURATION
    imports UKM-SEMANTICS-HOOKS-BYTES-CONFIGURATION
    imports UKM-SEMANTICS-HOOKS-STATE-CONFIGURATION
    configuration
        <ukm>
            <ukm-bytes/>
            <ukm-state/>
        </ukm>
endmodule

```
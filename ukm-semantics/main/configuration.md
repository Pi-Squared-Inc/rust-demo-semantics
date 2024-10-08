```k

requires "hooks/bytes.md"
requires "hooks/state.md"

module UKM-CONFIGURATION
    imports UKM-HOOKS-BYTES-CONFIGURATION
    imports UKM-HOOKS-STATE-CONFIGURATION
    configuration
        <ukm>
            <ukm-bytes/>
            <ukm-state/>
        </ukm>
endmodule

```
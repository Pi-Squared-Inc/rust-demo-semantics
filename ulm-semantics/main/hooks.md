```k

requires "hooks/bytes.md"
requires "hooks/debug.md"
requires "hooks/helpers.md"
requires "hooks/state.md"
requires "hooks/ulm.md"
requires "ulm.k"

module ULM-SEMANTICS-HOOKS
    imports private ULM-SEMANTICS-HOOKS-BYTES
    // Not including ULM-SEMANTICS-HOOKS-NO-DEBUG or ULM-SEMANTICS-HOOKS-DEBUG
    // here, they should be included directly in the target module.
    imports private ULM-SEMANTICS-HOOKS-HELPERS
    imports private ULM-SEMANTICS-HOOKS-STATE
    imports private ULM-SEMANTICS-HOOKS-ULM
endmodule

```

```k

requires "accounts/code-tools.md"
requires "accounts/esdt-hooks.md"
requires "accounts/storage-hooks.md"
requires "accounts/storage-tools.md"
requires "accounts/tools.md"
requires "biguint/hooks.md"
requires "biguint/tools.md"
requires "blocks/hooks.md"
requires "call-state/tools.md"
requires "calls/hooks.md"
requires "calls/tools.md"
requires "tools.md"

module MX-COMMON
    imports private MX-ACCOUNTS-CODE-TOOLS
    imports private MX-ACCOUNTS-ESDT-HOOKS
    imports private MX-ACCOUNTS-TOOLS
    imports private MX-BIGUINT-HOOKS
    imports private MX-BIGUINT-TOOLS
    imports private MX-BLOCKS-HOOKS
    imports private MX-CALL-STATE-TOOLS
    imports private MX-CALLS-HOOKS
    imports private MX-CALLS-TOOLS
    imports private MX-STORAGE-HOOKS
    imports private MX-STORAGE-TOOLS
    imports private MX-TOOLS
endmodule

```
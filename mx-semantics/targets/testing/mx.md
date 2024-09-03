```k

requires "configuration.md"
requires "../../main/mx-common.md"
requires "../../main/communication-mocks.md"
requires "../../main/syntax.md"
requires "../../test/execution.md"

module MX-SYNTAX
    imports MX-COMMON-SYNTAX
    imports MX-TEST-EXECUTION-PARSING-SYNTAX
endmodule

module MX
    imports private MX-COMMON
    imports private MX-COMMUNICATION-MOCKS
    imports private MX-CONFIGURATION
    imports private MX-TEST-EXECUTION
endmodule

```
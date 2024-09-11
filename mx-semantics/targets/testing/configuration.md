```k

requires "../../test/configuration.md"
requires "../../main/configuration.md"

module COMMON-K-CELL
    imports private MX-TEST-EXECUTION-PARSING-SYNTAX

    configuration
        <k> $PGM:MxTest </k>
endmodule

module MX-CONFIGURATION
    imports COMMON-K-CELL
    imports MX-COMMON-CONFIGURATION
    imports MX-TEST-CONFIGURATION

    configuration
        <mx-cfg>
            <mx-common/>
            <mx-test/>
            <k/>
        </mx-cfg>
endmodule

```

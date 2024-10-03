```k

requires "../../main/configuration.md"
requires "../../main/preprocessed-configuration.md"
requires "../../test/configuration.md"
requires "rust-semantics/config.md"
requires "rust-semantics/test/configuration.md"

module COMMON-K-CELL
    imports private RUST-EXECUTION-TEST-PARSING-SYNTAX
    imports private RUST-PREPROCESSING-SYNTAX

    configuration
        <k>
            crateParser($CRATE1:Crate)
            ~> crateParser($CRATE2:Crate)
            ~> crateParser($CRATE3:Crate)
            ~> crateParser($CRATE4:Crate)
            ~> $TEST:ExecutionTest
        </k>
endmodule

module UKM-TARGET-CONFIGURATION
    imports COMMON-K-CELL
    imports RUST-EXECUTION-CONFIGURATION
    imports UKM-CONFIGURATION
    imports UKM-FULL-PREPROCESSED-CONFIGURATION
    imports UKM-TEST-CONFIGURATION

    configuration
        <ukm-target>
            <ukm-full-preprocessed/>
            <ukm/>
            <ukm-test/>
            <execution/>
            <k/>
        </ukm-target>
endmodule

```

```k

module COMMON-K-CELL
    imports private RUST-EXECUTION-TEST-PARSING-SYNTAX
    imports private RUST-PREPROCESSING-SYNTAX

    configuration
        <k> cratesParser($PGM:WrappedCrateList)
            ~> $TEST:ExecutionTest
        </k>
endmodule

module RUST-RUNNING-CONFIGURATION
    imports COMMON-K-CELL
    imports RUST-CONFIGURATION
    imports RUST-EXECUTION-TEST-CONFIGURATION

    configuration
        <rust-mx>
            <rust-test/>
            <rust/>
            <k/>
        </rust-mx>
endmodule

```

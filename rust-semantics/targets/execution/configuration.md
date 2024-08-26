```k

module RUST-RUNNING-CONFIGURATION
    imports private RUST-PREPROCESSING-SYNTAX
    imports private RUST-EXECUTION-TEST-PARSING-SYNTAX
    imports RUST-CONFIGURATION
    imports RUST-EXECUTION-TEST-CONFIGURATION

    configuration
        <rust-mx>
            <k> crateParser($PGM:Crate) ~> $TEST:ExecutionTest </k>
            <rust/>
            <rust-test/>
        </rust-mx>
endmodule

```

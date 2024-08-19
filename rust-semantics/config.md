```k

module RUST-CONFIGURATION
    imports RUST-INDEXING-CONFIGURATION

    configuration
        <rust>
            <crate/>
        </rust>

endmodule

module RUST-RUNNING-CONFIGURATION
    imports private RUST-INDEXING-SYNTAX
    imports RUST-CONFIGURATION

    configuration
        <rust-mx>
            <k> crateParser($PGM:Crate) </k>
            <rust/>
        </rust-mx>
endmodule

```

```k

module RUST-CONFIGURATION
    imports RUST-PREPROCESSING-CONFIGURATION

    configuration
        <rust>
            <preprocessed/>
        </rust>

endmodule

module RUST-RUNNING-CONFIGURATION
    imports private RUST-PREPROCESSING-SYNTAX
    imports RUST-CONFIGURATION

    configuration
        <rust-mx>
            <k> crateParser($PGM:Crate) </k>
            <rust/>
        </rust-mx>
endmodule

```

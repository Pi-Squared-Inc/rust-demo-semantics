```k

module COMMON-K-CELL
    imports private RUST-PREPROCESSING-SYNTAX

    configuration
        <k> crateParser($PGM:Crate) </k>

endmodule

module RUST-RUNNING-CONFIGURATION
    imports COMMON-K-CELL
    imports RUST-PREPROCESSING-CONFIGURATION

    configuration
        <rust-mx>
            <rust>
                <preprocessed/>
            </rust>
            <k/>
        </rust-mx>
endmodule

```

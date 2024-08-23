```k
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

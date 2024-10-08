```k

module RUST-EXECUTION-TEST-CONFIGURATION
    imports LIST

    configuration
        <rust-test>
            <test-stack> .List </test-stack>
            <mocks> .Map </mocks>
        </rust-test>
endmodule

```
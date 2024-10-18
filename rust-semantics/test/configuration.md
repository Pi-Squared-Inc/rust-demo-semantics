```k

module RUST-EXECUTION-TEST-CONFIGURATION
    imports LIST

    configuration
        <rust-test>
            <test-stack> .List </test-stack>
            <mocks> .Map </mocks>
            <mock-list> .List </mock-list>
        </rust-test>
endmodule

```
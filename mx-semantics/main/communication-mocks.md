```k

module MX-COMMUNICATION-MOCKS
    imports MX-COMMON-SYNTAX

    // TODO: These should save/restore the `<stack>` cell. It should be implemented in
    // the part of the semantics that binds mx with rust.
    rule pushCallState => .K
    rule popCallState => .K

    // TODO: This should reset the rust cell. It should be implemented in
    // the part of the semantics that binds mx with rust.
    rule resetCallState => .K

endmodule

```

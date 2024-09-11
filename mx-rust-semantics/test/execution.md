```k

module MX-RUST-TESTING-PARSING-SYNTAX
    imports INT-SYNTAX
    imports MX-TEST-EXECUTION-PARSING-SYNTAX
    imports RUST-EXECUTION-TEST-PARSING-SYNTAX
    imports RUST-SHARED-SYNTAX
    imports RUST-VALUE-SYNTAX
    imports STRING-SYNTAX

    syntax MxRustTest ::= ExecutionTest
    syntax ExecutionItem  ::= "set_named" String
                            | "push_named" String
                            | "get_bigint_from_struct"
                            | "check_eq" Int
                            | TestInstruction

endmodule

module MX-RUST-TEST
    imports private COMMON-K-CELL
    imports private MX-RUST-EXECUTION-TEST-CONFIGURATION
    imports private MX-RUST-TESTING-PARSING-SYNTAX
    imports private RUST-EXECUTION-CONFIGURATION

    rule
        <k> set_named Name:String => .K ... </k>
        <test-stack> ListItem(Value) => .List ... </test-stack>
        <test-named> M:Map => M[Name <- Value] </test-named>

    rule
        <k> push_named Name:String => .K ... </k>
        <test-stack> .List => ListItem(Value)  ... </test-stack>
        <test-named> Name |-> Value ... </test-named>

    rule
        <k>
            ptrValue
                ( _
                , struct
                    ( #token("BigUint", "Identifier")
                    , #token("mx_biguint_id", "Identifier"):Identifier |-> BigUintIdId _:Map
                    )
                )
            ~> get_bigint_from_struct ; Test:ExecutionTest
            => push mxIntValue(MInt2Unsigned(BigUintId))
                ~> get_big_int
                ~> Test
            ...
        </k>
        <values> BigUintIdId |-> i32(BigUintId:MInt{32}) ... </values>
endmodule

```

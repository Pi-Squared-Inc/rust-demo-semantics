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
                            | "catch_error" String
                            | "get_bigint_from_struct"
                            | "check_eq" Int
                            | TestInstruction

endmodule

module MX-RUST-TEST
    imports private COMMON-K-CELL
    imports private K-EQUAL-SYNTAX
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
        ptrValue
            ( _
            , struct
                ( #token("BigUint", "Identifier")
                , _:Map
                ) #as S:Value
            )
        ~> get_bigint_from_struct
        => mxRustGetBigIntFromStruct(S)

    rule #exception(_, Message) ~> catch_error Message => .K  [priority(30)]
    rule (#exception(_, Message1) #as E:MxInstructions) ~> (catch_error Message2 #as C)
        => catch_error C ~> E
        requires Message1 =/=K Message2
        [priority(30)]
endmodule

```

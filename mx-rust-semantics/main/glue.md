```k

module MX-RUST-GLUE
  imports private COMMON-K-CELL
  imports private MX-COMMON-SYNTAX
  imports private RUST-EXECUTION-CONFIGURATION
  imports private RUST-VALUE-SYNTAX
  imports private MX-RUST-REPRESENTATION

  rule
      <k>
          storeHostValue
              (... destination: rustDestination(ValueId)
              , value: wrappedRust(V:Value)
              )
          => .K
          ...
      </k>
      <values> Values:Map => Values[ValueId <- V] </values>

  rule
      <k>
          mxRustLoadPtr(P:Int) => ptrValue(ptr(P), V)
          ...
      </k>
      <values> P |-> V:Value ... </values>
endmodule

```

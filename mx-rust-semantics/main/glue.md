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
              (... destination: rustDestination(ValueId, _:MxRustType)
              , value: wrappedRust(V:Value)
              )
          => .K
          ...
      </k>
      <values> Values:Map => Values[ValueId <- V] </values>
      requires ValueId >=Int 0

  rule
      (.K => mxRustEmptyValue(T))
      ~>  storeHostValue
              (... destination: rustDestination(_, T:MxRustType)
              , value: mxWrappedEmpty
              )
  rule
      (ptrValue(_, V:Value) => .K)
      ~>   storeHostValue
              (... value: mxWrappedEmpty => wrappedRust(V)
              )

  rule
      <k>
          mxRustLoadPtr(P:Int) => ptrValue(ptr(P), V)
          ...
      </k>
      <values> P |-> V:Value ... </values>

    rule
        <k> mxRustNewValue(V:Value) => ptrValue(ptr(NextId), V) ... </k>
        <next-value-id> NextId:Int => NextId +Int 1 </next-value-id>
        <values> Values:Map => Values[NextId <- V] </values>

    rule mxIntValue(I:Int) ~> mxValueToRust(T:Type)
        => mxRustNewValue(integerToValue(I, T))
endmodule

```
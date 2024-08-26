```k

module RUST-EXECUTION-CONFIGURATION
    imports INT
    imports LIST
    imports MAP

    configuration
        <execution>
            <values> .Map </values>  // Map from ValueId:Int |-> Value
            <locals> .Map </locals>  // Map from Identifier |-> ValueId:Int
            <stack> .List </stack>  // list of locals map.
            <next-value-id> 0 </next-value-id>
        </execution>
endmodule

```

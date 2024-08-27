```k

module MX-BIGUINT-HOOKS
    imports BOOL
    imports COMMON-K-CELL
    imports MX-BIGUINT-CONFIGURATION
    imports MX-COMMON-SYNTAX

    rule
        <k> MX#bigIntNew(mxIntValue(Value:Int)) => mxIntValue(NextId) ... </k>
        <bigIntHeap> Ints:Map => Ints[NextId <- Value] </bigIntHeap>
        <bigIntHeapNextId> NextId => NextId +Int 1 </bigIntHeapNextId>

    rule
        <k> MX#bigIntAdd(mxIntValue(Id1:Int) , mxIntValue(Id2:Int))
            => mxIntValue(NextId)
            ...
        </k>
        <bigIntHeap>
            Ints:Map
            => Ints [ NextId
                    <-  {Ints[Id1] orDefault 0}:>Int
                        +Int {Ints[Id2] orDefault 0}:>Int
                    ]
        </bigIntHeap>
        <bigIntHeapNextId> NextId => NextId +Int 1 </bigIntHeapNextId>
        requires Id1 in_keys(Ints) andBool isInt(Ints[Id1] orDefault 0)
            andBool Id2 in_keys(Ints) andBool isInt(Ints[Id2] orDefault 0)
endmodule

```

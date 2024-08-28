```k

module MX-BIGUINT-HOOKS
    imports BOOL
    imports COMMON-K-CELL
    imports K-EQUAL-SYNTAX
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

    rule
        <k> MX#bigIntSub(mxIntValue(Id1:Int) , mxIntValue(Id2:Int))
            => mxIntValue(NextId)
            ...
        </k>
        <bigIntHeap>
            Ints:Map
            => Ints [ NextId
                    <-  {Ints[Id1] orDefault 0}:>Int
                        -Int {Ints[Id2] orDefault 0}:>Int
                    ]
        </bigIntHeap>
        <bigIntHeapNextId> NextId => NextId +Int 1 </bigIntHeapNextId>
        requires Id1 in_keys(Ints) andBool isInt(Ints[Id1] orDefault 0)
            andBool Id2 in_keys(Ints) andBool isInt(Ints[Id2] orDefault 0)

    rule
        <k> MX#bigIntMul(mxIntValue(Id1:Int) , mxIntValue(Id2:Int))
            => mxIntValue(NextId)
            ...
        </k>
        <bigIntHeap>
            Ints:Map
            => Ints [ NextId
                    <-  {Ints[Id1] orDefault 0}:>Int
                        *Int {Ints[Id2] orDefault 0}:>Int
                    ]
        </bigIntHeap>
        <bigIntHeapNextId> NextId => NextId +Int 1 </bigIntHeapNextId>
        requires Id1 in_keys(Ints) andBool isInt(Ints[Id1] orDefault 0)
            andBool Id2 in_keys(Ints) andBool isInt(Ints[Id2] orDefault 0)

    rule
        <k> MX#bigIntDiv(mxIntValue(Id1:Int) , mxIntValue(Id2:Int))
            => mxIntValue(NextId)
            ...
        </k>
        <bigIntHeap>
            Ints:Map
            => Ints [ NextId
                    <-  {Ints[Id1] orDefault 0}:>Int
                        /Int {Ints[Id2] orDefault 0}:>Int
                    ]
        </bigIntHeap>
        <bigIntHeapNextId> NextId => NextId +Int 1 </bigIntHeapNextId>
        requires Id1 in_keys(Ints) andBool isInt(Ints[Id1] orDefault 0)
            andBool Id2 in_keys(Ints) andBool isInt(Ints[Id2] orDefault 0)
            andBool Ints[Id2] orDefault 0 =/=K 0

    rule
        <k> MX#bigIntCmp(mxIntValue(Id1:Int) , mxIntValue(Id2:Int))
            => mxIntValue
                ( #cmpInt
                  ( {Ints[Id1] orDefault 0}:>Int
                  , {Ints[Id2] orDefault 0}:>Int
                  )
                )
            ...
        </k>
        <bigIntHeap> Ints:Map </bigIntHeap>
        requires Id1 in_keys(Ints) andBool isInt(Ints[Id1] orDefault 0)
            andBool Id2 in_keys(Ints) andBool isInt(Ints[Id2] orDefault 0)

    syntax Int ::= #cmpInt ( Int , Int ) [function, total, symbol(cmpInt), smtlib(cmpInt)]
    rule #cmpInt(I1, I2) => -1 requires I1  <Int I2
    rule #cmpInt(I1, I2) =>  1 requires I1  >Int I2
    rule #cmpInt(I1, I2) =>  0 requires I1 ==Int I2

endmodule

```

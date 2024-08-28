```k

module MX-TEST-EXECUTION-PARSING-SYNTAX
    imports INT-SYNTAX
    imports MX-COMMON-SYNTAX
    imports STRING-SYNTAX

    syntax TestInstruction  ::= "push" MxValue
                              | "call" argcount:Int MxHookName
                              | "get_big_int"
                              | getBigint(Int)
                              | "check_eq" MxValue
                              | setCaller(String)
                              | addAccount(String)
                              | setBalance(account:String, token:String, nonce:Int, value:Int)
                              | setBlockTimestamp(Int)

    syntax MxTest ::= NeList{TestInstruction, ";"}

    syntax MxValueStack ::= List{MxValue, ","}
endmodule

module MX-TEST-EXECUTION
    imports private COMMON-K-CELL
    imports private INT
    imports private MX-ACCOUNTS-TEST
    imports private MX-BIGUINT-TEST
    imports private MX-BLOCKS-TEST
    imports private MX-CALL-TEST
    imports private MX-TEST-CONFIGURATION
    imports private MX-TEST-EXECUTION-PARSING-SYNTAX

    rule I:TestInstruction ; Is:MxTest => I ~> Is
    rule .MxTest => .K

    rule
        <k> push V:MxValue => .K ... </k>
        <mx-test-stack> L:MxValueStack => V , L </mx-test-stack>

    rule
        <k> call N:Int Hook:MxHookName => Hook(takeArgs(N, L)) ... </k>
        <mx-test-stack> L:MxValueStack => drop(N, L) </mx-test-stack>

    rule
        <k> V:MxValue => .K ... </k>
        <mx-test-stack> L:MxValueStack => V , L </mx-test-stack>

    rule
        <k> get_big_int => testGetBigInt(IntId) ... </k>
        <mx-test-stack> mxIntValue(IntId) , L:MxValueStack => L </mx-test-stack>

    rule
        <k> check_eq V => .K ... </k>
        <mx-test-stack> V , L:MxValueStack => L </mx-test-stack>

    syntax MxHookArgs ::= takeArgs(Int, MxValueStack)  [function, total]
    rule takeArgs(N:Int, _:MxValueStack) => .MxHookArgs
        requires N <=Int 0
    rule takeArgs(N:Int, (V:MxValue ,  Vs:MxValueStack)) => V , takeArgs(N -Int 1, Vs)
        requires 0 <Int N

    syntax MxValueStack ::= drop(Int, MxValueStack)  [function, total]
    rule drop(N:Int, Vs:MxValueStack) => Vs
        requires N <=Int 0
    rule drop(N:Int, (_V:MxValue ,  Vs:MxValueStack)) => drop(N -Int 1, Vs)
        requires 0 <Int N
endmodule

module MX-BIGUINT-TEST
    imports private BOOL
    imports private COMMON-K-CELL
    imports INT
    imports private MAP
    imports private MX-BIGUINT-CONFIGURATION
    imports private MX-COMMON-SYNTAX

    syntax TestInstruction ::= testGetBigInt(Int)

    rule
        <k> testGetBigInt(IntId:Int)
            => mxIntValue({Ints[IntId] orDefault 0}:>Int)
            ...
        </k>
        <bigIntHeap> Ints:Map </bigIntHeap>
        <bigIntHeapNextId> NextId => NextId +Int 1 </bigIntHeapNextId>
        requires IntId in_keys(Ints) andBool isInt(Ints[IntId] orDefault 0)

endmodule

module MX-CALL-TEST
    imports private COMMON-K-CELL
    imports private MX-CALL-CONFIGURATION
    imports private MX-TEST-EXECUTION-PARSING-SYNTAX

    rule
        <k> setCaller(S:String) => .K ... </k>
        <mx-caller> _ => S </mx-caller>
endmodule

module MX-ACCOUNTS-TEST
    imports private COMMON-K-CELL
    imports private MX-ACCOUNTS-CONFIGURATION
    imports private MX-TEST-EXECUTION-PARSING-SYNTAX

    rule
        <k> addAccount(S:String) => .K ... </k>
        <mx-accounts>
            .Bag
            =>  <mx-account>
                    <mx-account-address> S </mx-account-address>
                    <mx-esdt-datas> .Bag </mx-esdt-datas>
                </mx-account>
        </mx-accounts>

    rule
        <k> setBalance
                (... account: Account:String
                , token: TokenName:String
                , nonce: Nonce:Int
                , value: Value:Int
                ) => .K
            ...
        </k>
        <mx-account-address> Account </mx-account-address>
        <mx-esdt-id>
            <mx-esdt-id-name> TokenName </mx-esdt-id-name>
            <mx-esdt-id-nonce> Nonce </mx-esdt-id-nonce>
        </mx-esdt-id>
        <mx-esdt-balance> _ => Value </mx-esdt-balance>
        [priority(50)]

    rule
        <k> setBalance
                (... account: Account:String
                , token: TokenName:String
                , nonce: Nonce:Int
                , value: Value:Int
                ) => .K
            ...
        </k>
        <mx-account-address> Account </mx-account-address>
        <mx-esdt-datas>
            .Bag =>
                <mx-esdt-data>
                    <mx-esdt-id>
                        <mx-esdt-id-name> TokenName </mx-esdt-id-name>
                        <mx-esdt-id-nonce> Nonce </mx-esdt-id-nonce>
                    </mx-esdt-id>
                    <mx-esdt-balance> Value </mx-esdt-balance>
                </mx-esdt-data>
        </mx-esdt-datas>
        [priority(100)]

endmodule

module MX-BLOCKS-TEST
    imports private COMMON-K-CELL
    imports private MX-BLOCKS-CONFIGURATION
    imports private MX-TEST-EXECUTION-PARSING-SYNTAX

    rule
        <k> setBlockTimestamp(T:Int) => .K ... </k>
        <mx-current-block-timestamp> _ => T </mx-current-block-timestamp>

endmodule

```

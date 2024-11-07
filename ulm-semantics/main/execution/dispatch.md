```k

module ULM-EXECUTION-DISPATCH
    imports private BYTES-SYNTAX
    imports private COMMON-K-CELL
    imports private K-EQUAL-SYNTAX
    imports private RUST-REPRESENTATION
    imports private RUST-VALUE-SYNTAX
    imports private RUST-EXECUTION-CONFIGURATION
    imports private ULM-COMMON-TOOLS-SYNTAX
    imports private ULM-EXECUTION-SYNTAX
    imports private ULM-PREPROCESSING-CONFIGURATION
    imports private ULM-SEMANTICS-HOOKS-STATE-CONFIGURATION

    syntax UlmInstruction ::= ulmExecute(create: Bool, contract:Value, gas: ValueOrError)
                            | setContractOutput(Bytes)

    rule
        <k>
            // TODO: For some reason, kompile rejects 'Create' as a variabler name below.
            // Figure out why.
            ulmExecute(Createy:Bool, Pgm:Bytes, _AccountId:Int, Gas:Int)
            => ulmExecute(Createy, struct(ContractTrait, .Map), integerToValue(Gas, u64))
              ~> #if Createy #then setContractOutput(Pgm) #else .K #fi
            ...
        </k>
        <ulm-contract-trait>
            ContractTrait:TypePath
        </ulm-contract-trait>
    rule
        <k>
            ulmExecute(... create: Createy:Bool, contract: Contract:Value, gas: Gas:Value)
            => ptr(NVI) . dispatcherMethodIdentifier
                  ( ptrValue(null, Createy)
                  , ptrValue(null, Gas)
                  , .CallParamsList
                  )
            ...
        </k>
        <values> Values:Map => Values[NVI <- Contract] </values>
        <next-value-id> NVI:Int => NVI +Int 1 </next-value-id>
        requires notBool NVI in_keys(Values)

    rule
        <k> _:PtrValue ~> setContractOutput(B:Bytes) => .K ... </k>
        <ulm-output> _ => B </ulm-output>

endmodule

```

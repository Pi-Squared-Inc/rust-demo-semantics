```k

module UKM-EXECUTION-DISPATCH
    imports private BYTES-SYNTAX
    imports private COMMON-K-CELL
    imports private K-EQUAL-SYNTAX
    imports private RUST-REPRESENTATION
    imports private RUST-VALUE-SYNTAX
    imports private RUST-EXECUTION-CONFIGURATION
    imports private UKM-COMMON-TOOLS-SYNTAX
    imports private UKM-EXECUTION-SYNTAX
    imports private UKM-PREPROCESSING-CONFIGURATION

    syntax UkmInstruction ::= ukmExecute(create: Bool, contract:Value, gas: ValueOrError)

    rule
        <k>
            // TODO: For some reason, kompile rejects 'Create' as a variabler name below.
            // Figure out why.
            ukmExecute(Createy:Bool, Pgm:Bytes, _AccountId:Int, Gas:Int)
            => ukmExecute(Createy, struct(ContractTrait, .Map), integerToValue(Gas, u64))
              ~> #if Createy #then Pgm #else .K #fi
            ...
        </k>
        <ukm-contract-trait>
            ContractTrait:TypePath
        </ukm-contract-trait>
    rule
        <k>
            ukmExecute(... create: Createy:Bool, contract: Contract:Value, gas: Gas:Value)
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
endmodule

```

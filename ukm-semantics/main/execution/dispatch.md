```k

module UKM-EXECUTION-DISPATCH
    imports private COMMON-K-CELL
    imports private RUST-REPRESENTATION
    imports private RUST-VALUE-SYNTAX
    imports private RUST-EXECUTION-CONFIGURATION
    imports private UKM-EXECUTION-SYNTAX
    imports private UKM-PREPROCESSING-CONFIGURATION
    imports private UKM-REPRESENTATION

    syntax UkmInstruction ::= ukmExecute(contract:Value, gas: ValueOrError)

    rule
        <k>
            ukmExecute(_AccountId:Int, Gas:Int)
            => ukmExecute(struct(ContractTrait, .Map), integerToValue(Gas, u64))
            ...
        </k>
        <ukm-contract-trait>
            ContractTrait:TypePath
        </ukm-contract-trait>
    rule
        <k>
            ukmExecute(... contract: Contract:Value, gas: Gas:Value)
            => ptr(NVI) . dispatcherMethodIdentifier ( ptrValue(null, Gas), .CallParamsList )
            ...
        </k>
        <values> Values:Map => Values[NVI <- Contract] </values>
        <next-value-id> NVI:Int => NVI +Int 1 </next-value-id>
        requires notBool NVI in_keys(Values)
endmodule

```

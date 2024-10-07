```k

module MX-RUST-MODULES-BLOCKCHAIN
    imports private COMMON-K-CELL
    imports private MX-COMMON-SYNTAX
    imports private MX-RUST-REPRESENTATION
    imports private MX-RUST-REPRESENTATION-CONVERSIONS
    imports private RUST-EXECUTION-CONFIGURATION
    imports private RUST-SHARED-SYNTAX

    syntax Identifier ::= "MxRust#Blockchain"  [token]

    syntax MxRustStructType ::= "blockchainType"  [function, total]
    rule blockchainType
        => rustStructType
            ( MxRust#Blockchain
            , .MxRustStructFields
            )

    rule
        normalizedFunctionCall
            ( MxRust#Blockchain
                :: #token("new", "Identifier"):Identifier
            , .PtrList
            )
        =>  mxRustNewStruct
                ( blockchainType
                , .CallParamsList
                )

    rule
        normalizedMethodCall
            ( MxRust#Blockchain
            , #token("get_caller", "Identifier"):Identifier
            ,   ( ptr(_SelfId:Int)
                , .PtrList
                )
            )
        => MX#getCaller ( .MxValueList )
            ~> mxValueToRust(#token("ManagedAddress", "Identifier"):Identifier)

    rule
        normalizedMethodCall
            ( MxRust#Blockchain
            , #token("get_block_timestamp", "Identifier"):Identifier
            ,   ( ptr(_SelfId:Int)
                , .PtrList
                )
            )
        => MX#getBlockTimestamp ( .MxValueList )
            ~> mxValueToRust(u64)

endmodule

```

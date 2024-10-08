```k

module MX-RUST-SETUP-MX
    imports private COMMON-K-CELL
    imports private MX-COMMON-SYNTAX
    imports private MX-RUST-PREPROCESSED-CONFIGURATION
    imports private MX-RUST-REPRESENTATION
    imports private MX-SETUP-SYNTAX
    imports private RUST-PREPROCESSING-CONFIGURATION
    imports private RUST-PREPROCESSING-SYNTAX

    syntax MXRustInstruction ::= "MxRust#addAccountWithPreprocessedCode"
                                      "(" owner: String
                                      "," newAddress: String
                                      "," egldValue: Int
                                      "," gasLimit: Int
                                      "," args: MxValueList
                                      ")"
    syntax MXRustInstruction  ::= "MxRust#addAccountWithPreprocessedCode" "(" String ")"
                                | "MxRust#clearMxReturnValue"

    rule mxRustCreateAccount(Address:String) => MXSetup#add_account(Address)

    rule mxRustCreateContract
            (... owner: Owner:String
            , contractAccount: Contract:String
            , code: Code:Crate
            , args: Args:MxValueList
            )
        =>  MxRust#clearPreprocessed
            ~> crateParser(Code, #token("contract", "Identifier"):Identifier)
            ~> mxRustPreprocessTraits
            ~> MxRust#addAccountWithPreprocessedCode
                (... owner: Owner
                , newAddress: Contract
                , egldValue: 0
                , gasLimit: 0
                , args: Args
                )

    // Trying to put the following three rules in one causes this kind of error:
    //
    // [Error] Internal: Uncaught exception thrown of type ClassCastException
    // (ClassCastException: class org.kframework.kore.ADT$KAs cannot be cast to class
    // org.kframework.kore.KRewrite (org.kframework.kore.ADT$KAs and
    // org.kframework.kore.KRewrite are in unnamed module of loader 'app'))
    //
    // most likely, this happes because we need this:
    //
    // <preprocessed> ... <trait-list> ListItem(TraitName:TypePath) </trait-list>  </preprocessed>
    //   #as Preprocessed:PreprocessedCell
    //
    // https://github.com/runtimeverification/k/issues/4638
    rule
        <k>
            MxRust#addAccountWithPreprocessedCode
                (...owner: Owner:String
                , newAddress: Contract:String
                , egldValue: EgldValue:Int
                , gasLimit: GasLimit:Int
                , args: Args:MxValueList
                )
            => MxRust#addAccountWithPreprocessedCode(Contract)
              ~> callContract
                  ( "#init"
                  , prepareIndirectContractCallInput
                        (... caller: Owner
                        , callee: Contract
                        , egldValue: EgldValue
                        , esdtTransfers: .MxEsdtTransferList
                        , gasLimit: GasLimit
                        , args:Args
                        )
                  )
              ~> finishExecuteOnDestContext
              ~> MxRust#clearMxReturnValue
            ...
        </k>

    rule
        <k>
            MxRust#addAccountWithPreprocessedCode(Contract)
            => MxRust#clearPreprocessed
                ~> MXSetup#add_account_with_code
                    ( Contract
                    , rustCode(MxRustPreprocessed, Preprocessed)
                    )
            ...
        </k>
        Preprocessed:PreprocessedCell
        MxRustPreprocessed:MxRustPreprocessedCell

    syntax MXRustInstruction ::= "MxRust#clearPreprocessed"
    rule
        <k>
            MxRust#clearPreprocessed => .K
            ...
        </k>
        (_:PreprocessedCell
        => <preprocessed> ... <trait-list> .List </trait-list>  </preprocessed>
        )
        (_:MxRustPreprocessedCell
        =>  <mx-rust-preprocessed>
                <mx-rust-endpoint-to-function> .Map </mx-rust-endpoint-to-function>
                ...
            </mx-rust-preprocessed>
        )

    rule _V:MxValue ~> MxRust#clearMxReturnValue => .K

endmodule

```

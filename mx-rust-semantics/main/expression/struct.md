```k

module MX-RUST-EXPRESSION-STRUCT
    imports private MX-RUST-REPRESENTATION

    syntax MapOrError ::= pair(MxRustStructFields, PtrList, Map)  [function, total]

    rule (.K => reverseNormalizeParams(Args, .PtrList))
        ~> mxRustNewStruct
            ( _
            , Args:CallParamsList
            )

    rule reverseNormalizeParams(.CallParamsList, Ptrs:PtrList)
        ~> mxRustNewStruct
            ( rustStructType
                ( StructName:TypePath
                , Fields:MxRustStructFields
                )
            , _:CallParamsList
            )
        => Rust#newStruct(StructName, pair(Fields, reverse(Ptrs, .PtrList), .Map))

    rule pair(.MxRustStructFields, .PtrList, M:Map) => M
    rule pair
            ( (mxRustStructField(Name:Identifier, _) , Fs:MxRustStructFields) => Fs
            , (ptr(P:Int) , Ps:PtrList) => Ps
            , M:Map => M[Name <- P]
            )
        requires notBool Name in_keys(M)
    rule pair(Fs, Ps, M)
        => error
            ( "Unspecified error (pair)"
            , ListItem(Fs) ListItem(Ps) ListItem(M)
            )
        [owise]

endmodule

```

```k

module MX-RUST-EXPRESSION-MX-TO-RUST
    imports private K-EQUAL-SYNTAX
    imports private MX-COMMON-SYNTAX
    imports private MX-RUST-REPRESENTATION
    imports private RUST-HELPERS
    imports private RUST-VALUE-SYNTAX

    syntax Bool ::= isMxToRustValue(K)  [function, total, symbol(isMxToRustValue)]
    rule isMxToRustValue(_:K) => false [owise]
    rule isMxToRustValue(_:PtrValue) => true
    rule isMxToRustValue(mxToRustField(_, V:MxToRust)) => isMxToRustValue(V)

    syntax Bool ::= isMxToRustFieldValue(K)  [function, total, symbol(isMxToRustFieldValue)]
    rule isMxToRustFieldValue(_:K) => false [owise]
    rule isMxToRustFieldValue(_:PtrValue) => true
    rule isMxToRustFieldValue(mxToRustField(_, V:MxToRust)) => isMxToRustValue(V)
    rule isMxToRustFieldValue(.MxRustFieldValues) => true
    rule isMxToRustFieldValue(A:MxRustFieldValue , As:MxRustFieldValues)
        => isMxToRustFieldValue(A) andBool isMxToRustFieldValue(As)

    rule V:MxValue ~> mxToRustTyped(T:Type) => mxToRustTyped(T, V)

    rule mxToRustTyped(T:Type, mxIntValue(I:Int)) => mxRustNewValue(integerToValue(I, T))
        requires
            (T ==K i32 orBool T ==K u32)
            orBool (T ==K i64 orBool T ==K u64)
    rule mxToRustTyped(str, mxStringValue(S:String)) => mxRustNewValue(S)
    rule mxToRustTyped
            ( rustStructType(StructName:TypePath, Fields:MxRustStructFields)
            , mxListValue(Values:MxValueList)
            )
        => mxToRustStruct(StructName, pairFields(Fields, Values))
    rule mxToRustTyped(() , mxUnitValue()) => ptrValue(null, tuple(.ValueList))

    context HOLE:MxRustFieldValue , _:MxRustFieldValues [result(MxToRustFieldValue)]
    context V:MxRustFieldValue , HOLE:MxRustFieldValues requires isMxToRustFieldValue(V)
        [result(MxToRustFieldValue)]

    syntax MxRustFieldValues ::= pairFields(MxRustStructFields, MxValueList)  [function, total]
    rule pairFields(.MxRustStructFields, .MxValueList) => .MxRustFieldValues
    rule pairFields
            ( (mxRustStructField(Name:Identifier, T:MxRustType) , Fs:MxRustStructFields)
            , (V:MxValue , Vs:MxValueList)
            )
        => mxToRustField(Name, mxToRustTyped(T, V)) , pairFields(Fs, Vs)
    rule pairFields(.MxRustStructFields, (_:MxValue , _:MxValueList) #as L:MxValueList)
        => error("Not enough fields", ListItem(L))
    rule pairFields((_ , _:MxRustStructFields) #as F, .MxValueList)
        => error("Not enough values", ListItem(F))
    rule pairFields(F:MxRustStructFields, V:MxValueList)
        => error("Should not happen (pairFields)", ListItem(F) ListItem(V))
        [owise]

    rule (.K => fieldsToMap(Fields, .Map))
        ~> mxToRustStruct(_StructName:TypePath, Fields:MxRustFieldValues)
        requires isMxToRustFieldValue(Fields)

    rule M:Map ~>  mxToRustStruct(StructName:TypePath, _Fields:MxRustFieldValues)
        => mxRustNewValue(struct(StructName, M))

    syntax MapOrError ::= fieldsToMap(MxRustFieldValues, Map)  [function, total]
    rule fieldsToMap(.MxRustFieldValues, M:Map) => M
    rule fieldsToMap
            ( mxToRustField(Name:Identifier, ptrValue(ptr(I:Int), _:Value))
                , Fields:MxRustFieldValues
            , M
            )
        => fieldsToMap(Fields, M[Name <- I])
        requires notBool Name in_keys(M)
    rule fieldsToMap
            (   ( (mxToRustField(Name:Identifier, _) #as Field:MxRustFieldValue)
                , _Fields:MxRustFieldValues
                )
            , M
            )
        => error("Field name already in map", ListItem(Field) ListItem(M))
        requires Name in_keys(M)
    rule fieldsToMap((Field , _:MxRustFieldValues), _:Map)
        => error("Unexpected field", ListItem(Field))
        [owise]
endmodule

```

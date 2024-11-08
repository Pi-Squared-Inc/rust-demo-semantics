```k
requires "plugin/krypto.md"

module ULM-ENCODING-HELPER
    imports private BYTES
    imports private INT-SYNTAX
    imports private KRYPTO
    imports private STRING
    imports private ULM-ENCODING-HELPER-SYNTAX

    // TODO: Error for argument of length 1 or string not hex
    rule encodeHexBytes(_:String) => .Bytes
        [owise]
    rule encodeHexBytes(S:String)
        => Int2Bytes(1, String2Base(substrString(S, 0, 2), 16), BE)
            +Bytes encodeHexBytes(substrString(S, 2, lengthString(S)))
        requires 2 <=Int lengthString(S) andBool isHex(substrString(S, 0, 2), 0)

    syntax Bool ::= isHex(String, idx:Int)  [function, total]
    rule isHex(S:String, I:Int) => true
        requires I <Int 0 orBool lengthString(S) <=Int I
    rule isHex(S:String, I:Int)
        => isHexDigit(substrString(S, I, I +Int 1)) andBool isHex(S, I +Int 1)
        requires 0 <=Int I andBool I <Int lengthString(S)

    syntax Bool ::= isHexDigit(String)  [function, total]
    rule isHexDigit(S)
        => ("0" <=String S andBool S <=String "9")
            orBool ("a" <=String S andBool S <=String "f")
            orBool ("A" <=String S andBool S <=String "F")

    // Encoding of individual types

    rule convertToKBytes(i8(V) , "int8") => Int2Bytes(32, MInt2Signed(V), BE:Endianness) 
    rule convertToKBytes(u8(V) , "uint8") => Int2Bytes(32, MInt2Unsigned(V), BE:Endianness) 
    rule convertToKBytes(i16(V), "int16") => Int2Bytes(32, MInt2Signed(V), BE:Endianness) 
    rule convertToKBytes(u16(V), "uint16") => Int2Bytes(32, MInt2Unsigned(V), BE:Endianness) 
    rule convertToKBytes(i32(V), "int32") => Int2Bytes(32, MInt2Signed(V), BE:Endianness) 
    rule convertToKBytes(u32(V), "uint32") => Int2Bytes(32, MInt2Unsigned(V), BE:Endianness) 
    rule convertToKBytes(i64(V), "int64") => Int2Bytes(32, MInt2Signed(V), BE:Endianness) 
    rule convertToKBytes(u64(V), "uint64") => Int2Bytes(32, MInt2Unsigned(V), BE:Endianness) 
    rule convertToKBytes(u128(V), "uint128") => Int2Bytes(32, MInt2Unsigned(V), BE:Endianness) 
    rule convertToKBytes(true,  "bool") => Int2Bytes(32, 1, BE:Endianness) 
    rule convertToKBytes(false, "bool") => Int2Bytes(32, 0, BE:Endianness)
    rule convertToKBytes(u256(V), "uint256") => Int2Bytes(32, MInt2Unsigned(V), BE:Endianness) 
    rule convertToKBytes(u160(V), "uint160") => Int2Bytes(32, MInt2Unsigned(V), BE:Endianness)  
    rule convertToKBytes(u160(V), "address") => Int2Bytes(32, MInt2Unsigned(V), BE:Endianness)  

endmodule

module ULM-CALLDATA-ENCODER
    imports private BYTES
    imports private INT-SYNTAX
    imports private KRYPTO
    imports private RUST-ERROR-SYNTAX
    imports private STRING
    imports private ULM-ENCODING-SYNTAX
    imports private ULM-ENCODING-HELPER-SYNTAX
    imports private ULM-ENCODING-HELPER

    syntax Identifier ::= "bytes_hooks"  [token]
                        | "append_bytes_raw"  [token]
                        | "append_u8"  [token]
                        | "append_u16"  [token]
                        | "append_u32"  [token]
                        | "append_u64"  [token]
                        | "append_u128"  [token]
                        | "append_u160"  [token]
                        | "append_u256"  [token]
                        | "append_bool"  [token]
                        | "append_str"  [token]
                        | "empty"  [token]
                        | "length"  [token]


    rule encodeFunctionSignatureAsBytes(FS)
        => encodeHexBytes(substrString(Keccak256(String2Bytes(FS)), 0, 8))
    rule encodeFunctionSignatureAsBytes(E:SemanticsError) => E

    rule encodeEventSignatureAsInt(FS)
        => Bytes2Int(Keccak256raw(String2Bytes(FS)), BE, Unsigned)
    rule encodeEventSignatureAsInt(E:SemanticsError) => E

    // TODO: it may be worth extracting the substrString(Keccak256(String2Bytes(FS)), 0, 8) 
    // thing to a function that takes a String and produces a String or Bytes (as opposed to
    // taking a StringOrError as below) (perhaps with an encodeAsBytes(...) on top of it) and 
    // then use it here and in the rules below.
    rule encodeCallData(FN:String, FAT:List, FAL:List) => 
           encodeFunctionSignature(FN, FAT) +Bytes encodeFunctionParams(FAL, FAT, b"")  
    rule encodeConstructorData(FAT:List, FAL:List) => 
           encodeFunctionParams(FAL, FAT, b"")  

    // Function signature encoding
    rule encodeFunctionSignature(FuncName:String, RL:List) => 
            encodeFunctionSignatureHelper(RL:List, FuncName +String "(") [priority(40)]
        
    rule encodeFunctionSignatureHelper(ListItem(FuncParam:String) RL:List, FS) => 
            encodeFunctionSignatureHelper(RL, FS +String FuncParam +String ",") [owise]
    
    // The last param does not have a follow up comma
    rule encodeFunctionSignatureHelper(ListItem(FuncParam:String) .List, FS) => 
            encodeFunctionSignatureHelper(.List, FS +String FuncParam ) 

    rule encodeFunctionSignatureHelper(.List, FS) => encodeHexBytes(substrString(Keccak256(String2Bytes(FS  +String ")")), 0, 8)) 

    // Function parameters encoding
    rule encodeFunctionParams(ListItem(V:Value) ARGS:List, ListItem(T:String) PTYPES:List, B:Bytes) =>
            encodeFunctionParams(ARGS:List, PTYPES:List, B:Bytes +Bytes convertToKBytes(V, T))

    rule encodeFunctionParams(.List, .List, B:Bytes) => B

    syntax Identifier ::= "ulm#head_size"  [token]
                        | "ulm#head"  [token]
                        | "ulm#tail"  [token]

    syntax NonEmptyStatementsOrError ::= #encodeStatements
                                            ( bufferId: Identifier
                                            , headSize: ExpressionOrError
                                            , append: NonEmptyStatementsOrError
                                            )  [function, total]

    rule encodeStatements(... bufferId: BufferId:Identifier, values: Values:EncodeValues)
        => #encodeStatements(BufferId, totalHeadSize(Values), appendValues(Values, ulm#head_size, ulm#head, ulm#tail))

    rule #encodeStatements(_BufferId:Identifier, e(HeadSize:SemanticsError), _AppendValues:NonEmptyStatementsOrError)
        => HeadSize
    rule #encodeStatements(_BufferId:Identifier, v(_HeadSize:Expression), AppendValues:SemanticsError)
        => AppendValues
    rule #encodeStatements(BufferId:Identifier, v(HeadSize:Expression), AppendValues:NonEmptyStatements)
        => concatNonEmptyStatements
            (   let ulm#head_size = HeadSize;
                let ulm#head = :: bytes_hooks :: empty ( .CallParamsList );
                let ulm#tail = :: bytes_hooks :: empty ( .CallParamsList );
                AppendValues
            ,   let BufferId = :: bytes_hooks :: append_bytes_raw ( BufferId, ulm#head , .CallParamsList);
                let BufferId = :: bytes_hooks :: append_bytes_raw ( BufferId, ulm#tail , .CallParamsList);
                .NonEmptyStatements
            )

    syntax ExpressionOrError ::= totalHeadSize(EncodeValues)  [function, total]
    rule totalHeadSize(.EncodeValues) => v(ptrValue(null, u32(0p32)))
    rule totalHeadSize(_:Expression : T:Type , Evs:EncodeValues)
        => addOrError(headSize(T), totalHeadSize(Evs))

    syntax NonEmptyStatementsOrError ::= appendValues
                                            ( values: EncodeValues
                                            , headSize: Expression
                                            , head: Expression
                                            , tail: Expression
                                            )  [function, total]
    rule appendValues(.EncodeValues, _HeadSize:Expression, _Head:Expression, _Tail:Expression)
        => .NonEmptyStatements
    rule appendValues
            ( V:Expression : T:Type , Evs:EncodeValues
            , HeadSize:Expression
            , Head:Expression
            , Tail:Expression
            )
        => concat(
            appendValue
                ( V
                , HeadSize
                , Head, Tail
                , appendType(T)
                )
        ,   appendValues(Evs, HeadSize, Head, Tail)
        )

    syntax AppendType ::= fixedSize(PathInExpression)
                        | variableSize(PathInExpression)
                        | "empty"
    syntax AppendTypeOrError ::= AppendType | SemanticsError
    syntax AppendTypeOrError ::= appendType(Type)  [function, total]

    rule appendType(u8  ) => fixedSize(:: bytes_hooks :: append_u8)
    rule appendType(u16 ) => fixedSize(:: bytes_hooks :: append_u16)
    rule appendType(u32 ) => fixedSize(:: bytes_hooks :: append_u32)
    rule appendType(u64 ) => fixedSize(:: bytes_hooks :: append_u64)
    rule appendType(u128) => fixedSize(:: bytes_hooks :: append_u128)
    rule appendType(u160) => fixedSize(:: bytes_hooks :: append_u160)
    rule appendType(u256) => fixedSize(:: bytes_hooks :: append_u256)

    rule appendType(bool) => fixedSize(:: bytes_hooks :: append_bool)
    rule appendType(()) => empty
    rule appendType(str) => variableSize(:: bytes_hooks :: append_str)
    rule appendType(T:Type)
        => error("appendType: unrecognized type", ListItem(T))
        [owise]

    syntax NonEmptyStatementsOrError ::= appendValue
                                            ( value: Expression
                                            , headSize: Expression
                                            , head: Identifier
                                            , tail: Identifier
                                            , appendFn: AppendTypeOrError
                                            )  [function, total]

      rule appendValue
              (... value: _Value:Expression
              , headSize: _HeadSize:Expression
              , head: _Head:Identifier
              , tail: _Tail:Identifier
              , appendFn: E:SemanticsError
              )
          =>  E
      rule appendValue
              (... value: Value:Expression
              , headSize: _HeadSize:Expression
              , head: Head:Identifier
              , tail: _Tail:Identifier
              , appendFn: fixedSize(P:PathInExpression)
              )
          =>  let Head = P ( Head , Value , .CallParamsList );
              .NonEmptyStatements
      rule appendValue
              (... value: Value:Expression
              , headSize: HeadSize:Expression
              , head: Head:Identifier
              , tail: Tail:Identifier
              , appendFn: variableSize(P:PathInExpression)
              )
          =>  let Head = :: bytes_hooks :: append_u32
                  ( Head
                  , HeadSize + (:: bytes_hooks :: length( Tail, .CallParamsList ))
                  , .CallParamsList
                  );
              let Tail = P ( Tail , Value , .CallParamsList );
              .NonEmptyStatements
      rule appendValue
              (... value: _Value:Expression
              , headSize: _HeadSize:Expression
              , head: _Head:Identifier
              , tail: _Tail:Identifier
              , appendFn: empty
              )
          =>  .NonEmptyStatements

    syntax ExpressionOrError ::= headSize(Type)  [function, total]
    rule headSize(u8  ) => v(ptrValue(null, u32(32p32)))
    rule headSize(u16 ) => v(ptrValue(null, u32(32p32)))
    rule headSize(u32 ) => v(ptrValue(null, u32(32p32)))
    rule headSize(u64 ) => v(ptrValue(null, u32(32p32)))
    rule headSize(u128) => v(ptrValue(null, u32(32p32)))
    rule headSize(u160) => v(ptrValue(null, u32(32p32)))
    rule headSize(u256) => v(ptrValue(null, u32(32p32)))

    rule headSize(bool) => v(ptrValue(null, u32(32p32)))
    rule headSize(()) => v(ptrValue(null, u32(0p32)))
    rule headSize(str) => v(ptrValue(null, u32(32p32)))
    rule headSize(T:Type)
        => e(error("headSize: unrecognized type", ListItem(T:Type:KItem)))
        [owise]

    rule methodSignature(S:String, Ps:NormalizedFunctionParameterList)
        => encodeFunctionSignatureAsBytes(concat(concat(S +String "(", signatureTypes(Ps)), ")"))

    rule eventSignature(S, Ps)
        => integerToValue
            ( encodeEventSignatureAsInt
                (concat(concat(S +String "(", signatureTypes(Ps)), ")"))
            , u256
            )

    syntax StringOrError  ::= signatureTypes(NormalizedFunctionParameterList)  [function, total]
                            | signatureType(Type)  [function, total]

    rule signatureTypes(.NormalizedFunctionParameterList) => ""
    rule signatureTypes(_ : T:Type , .NormalizedFunctionParameterList)
        => signatureType(T)
    rule signatureTypes
            ( _ : T:Type
            , ((_:NormalizedFunctionParameter , _:NormalizedFunctionParameterList)
                #as Ps:NormalizedFunctionParameterList)
            )
        => concat(signatureType(T), concat(",", signatureTypes(Ps)))

    rule signatureType(u8) => "uint8"
    rule signatureType(u16) => "uint16"
    rule signatureType(u32) => "uint32"
    rule signatureType(u64) => "uint64"
    rule signatureType(u128) => "uint128"
    // TODO: This is the wrong signature type. We should separate addresses from u160.
    rule signatureType(u160) => "address"
    rule signatureType(u256) => "uint256"
    rule signatureType(T) => error("Unknown type in signatureType:", ListItem(T))
        [owise]

    rule paramToEncodeValue(I:Identifier : T:Type) => I : T
    rule paramToEncodeValue(I:SelfSort : T:Type) => I : T

    rule paramsToEncodeValues(.NormalizedFunctionParameterList) => .EncodeValues
    rule paramsToEncodeValues(P:NormalizedFunctionParameter , Ps:NormalizedFunctionParameterList)
        => paramToEncodeValue(P) , paramsToEncodeValues(Ps)


endmodule

```
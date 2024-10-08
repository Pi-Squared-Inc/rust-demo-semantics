```k

module RUST-EXPRESSION-STRUCT
    imports private COMMON-K-CELL
    imports private RUST-CONVERSIONS-SYNTAX
    imports private RUST-ERROR-SYNTAX
    imports private RUST-EXECUTION-CONFIGURATION
    imports private RUST-PREPROCESSING-CONFIGURATION
    imports private RUST-REPRESENTATION

    // For freezing heating operations, when leaving a struct alone in the topcell, make it a ptrValue
    rule <k> struct(P, Fields) => ptrValue(null, struct(P, Fields)) ... </k>

    // KItems for breaking down struct expressions into the adequate format struct(P, F)
    syntax KItem ::= fromStructExpressionWithLiteralsBuildFieldsMap(TypePath, LiteralExpressionList, List, Map)
                   | fromStructExpressionWithAssignmentsBuildFieldsMap(TypePath, StructFieldAssignments, Map)


    // From Struct Expression to struct(P, F). Case 1, field names are not given:
    rule <k> 
            I:TypePath { L:LiteralExpressionList } => fromStructExpressionWithLiteralsBuildFieldsMap(I, L, VL, .Map) 
            ... 
         </k>
        <struct-path> I </struct-path>
        <variable-list> VL </variable-list>
        
    rule <k> fromStructExpressionWithLiteralsBuildFieldsMap(I:TypePath, (E:LiteralExpression, RL):LiteralExpressionList, FieldNameList:List, FieldsMap:Map)
                => E ~> fromStructExpressionWithLiteralsBuildFieldsMap(I, RL, FieldNameList, FieldsMap) ... 
         </k>

    rule 
        <k> 
            ptrValue(_, V:Value):PtrValue ~> 
            fromStructExpressionWithLiteralsBuildFieldsMap(
                    I:TypePath, 
                    RL:LiteralExpressionList, 
                    (FieldNameList):List ListItem(FieldName), 
                    FieldsMap:Map)
            => fromStructExpressionWithLiteralsBuildFieldsMap(I, RL, FieldNameList, FieldsMap (FieldName |-> NVI):Map )  
            ... 
        </k>
        <values> VALUES:Map => VALUES[NVI <- V] </values>
        <next-value-id> NVI:Int => NVI +Int 1 </next-value-id>

    rule <k> 
            fromStructExpressionWithLiteralsBuildFieldsMap(I:TypePath, .LiteralExpressionList, .List, FieldsMap:Map) 
                => struct(I, FieldsMap) 
            ... 
        </k>

    // From Struct Expression to struct(P, F). Case 2, field names are given:
    rule <k> 
            I:TypePath { S:StructFieldAssignments } => fromStructExpressionWithAssignmentsBuildFieldsMap(I, S, .Map) 
            ... 
         </k>

    rule <k> 
            fromStructExpressionWithAssignmentsBuildFieldsMap(
                    Name:TypePath, 
                    ((FieldName:Identifier : LE:LiteralExpression):StructFieldAssignment, RS):StructFieldAssignments,
                    FieldsMap:Map)
                => LE ~> FieldName ~> fromStructExpressionWithAssignmentsBuildFieldsMap(Name, RS, FieldsMap)
            ...
        </k>

    rule <k> 
            ptrValue(_, V:Value):PtrValue ~> FieldName:Identifier ~>
            fromStructExpressionWithAssignmentsBuildFieldsMap(
                Name:TypePath, 
                RS:StructFieldAssignments,
                FieldsMap:Map
            ) =>
            fromStructExpressionWithAssignmentsBuildFieldsMap(
                Name, RS, FieldsMap (FieldName |-> NVI):Map
            )
        ... 
        </k>
        <values> VALUES:Map => VALUES[NVI <- V] </values>
        <next-value-id> NVI:Int => NVI +Int 1 </next-value-id>

    rule <k> fromStructExpressionWithAssignmentsBuildFieldsMap(
                Name:TypePath, 
                .StructFieldAssignments,
                FieldsMap:Map
            ) => struct(Name, FieldsMap)
        ...
        </k>



    rule
        <k>
            normalizedMethodCall
                ( StructName:TypePath
                , #token("clone", "Identifier"):Identifier
                , (ptr(SelfPtr), .PtrList)
                )
            => ptrValue(ptr(NVI), struct(StructName, FieldValues))
            ...
        </k>
        <values>
            ( SelfPtr |-> struct(StructName, FieldValues:Map)
              _:Map
            ) #as Values
            => Values[NVI <- struct(StructName, FieldValues)]
        </values>
        <next-value-id> NVI:Int => NVI +Int 1 </next-value-id>

    rule
        <k> Rust#newStruct(P:TypePath, Fields:Map) => ptrValue(ptr(NVI), struct(P, Fields)) ... </k>
        <values> VALUES:Map => VALUES[NVI <- struct(P, Fields)] </values>
        <next-value-id> NVI:Int => NVI +Int 1 </next-value-id>

    rule
        <k>
            ptrValue(_, struct(_, FieldName |-> FieldValueId:Int _:Map)) . FieldName:Identifier
            => ptrValue(ptr(FieldValueId), V)
            ...
        </k>
        <values> FieldValueId |-> V:Value ... </values>
endmodule

```

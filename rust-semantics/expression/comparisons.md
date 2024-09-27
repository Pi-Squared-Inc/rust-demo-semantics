```k

module RUST-EXPRESSION-COMPARISONS
    imports private RUST-EXPRESSION-STRUCT-COMPARISONS
    imports private RUST-EXPRESSION-STRING-COMPARISONS
    imports private RUST-INTEGER-RELATIONAL-OPERATIONS
endmodule

module RUST-EXPRESSION-STRING-COMPARISONS
    imports private K-EQUAL-SYNTAX
    imports private RUST-SHARED-SYNTAX
    imports private RUST-REPRESENTATION

    rule ptrValue(_, A:String)  == ptrValue(_, B:String) => ptrValue(null, A ==K B)
endmodule

module RUST-EXPRESSION-STRUCT-COMPARISONS
    imports private RUST-CONVERSIONS-SYNTAX
    imports private RUST-ERROR-SYNTAX
    imports private RUST-REPRESENTATION

    // TODO: This should use std::cmp::PartialEq::eq
    rule (ptrValue(_, struct(StructName:TypePath, FirstFields:Map))
            == ptrValue(_, struct(StructName, SecondFields:Map))
        ):Expression
        => allPtrEquality
            ( listToPtrList(values(FirstFields))
            , listToPtrList(values(SecondFields))
            )
        [owise]

    syntax ExpressionOrError ::= allPtrEquality(PtrListOrError, PtrListOrError)
                                  [function, total]

    rule allPtrEquality(E:SemanticsError, _:PtrListOrError) => E
    rule allPtrEquality(_:PtrList, E:SemanticsError) => E

    rule allPtrEquality(.PtrList, .PtrList) => true
    rule allPtrEquality((P:Ptr , Ps:PtrList), (Q:Ptr , Qs:PtrList))
        => andOrError(P == Q , allPtrEquality(Ps, Qs))

    rule allPtrEquality(.PtrList, (_:Ptr , _:PtrList) #as Ps:PtrList)
        => error("allPtrEquality: Second list too long", ListItem(Ps))
    rule allPtrEquality((_:Ptr , _:PtrList) #as Ps:PtrList, .PtrList)
        => error("zip(PtrList): First list too long", ListItem(Ps))

endmodule

module RUST-INTEGER-RELATIONAL-OPERATIONS
    imports private RUST-SHARED-SYNTAX
    imports private RUST-REPRESENTATION

    rule ptrValue(_, i32(A):Value)  == ptrValue(_, i32(B):Value)  => ptrValue(null, A ==MInt  B)
    rule ptrValue(_, i32(A):Value)  != ptrValue(_, i32(B):Value)  => ptrValue(null, A =/=MInt B)
    rule ptrValue(_, i32(A):Value)  >  ptrValue(_, i32(B):Value)  => ptrValue(null, A >sMInt  B)
    rule ptrValue(_, i32(A):Value)  <  ptrValue(_, i32(B):Value)  => ptrValue(null, A <sMInt  B)
    rule ptrValue(_, i32(A):Value)  >= ptrValue(_, i32(B):Value)  => ptrValue(null, A >=sMInt B)
    rule ptrValue(_, i32(A):Value)  <= ptrValue(_, i32(B):Value)  => ptrValue(null, A <=sMInt B)

    rule ptrValue(_, u32(A):Value) == ptrValue(_, u32(B):Value)  => ptrValue(null, A ==MInt B)
    rule ptrValue(_, u32(A):Value) != ptrValue(_, u32(B):Value)  => ptrValue(null, A =/=MInt B)
    rule ptrValue(_, u32(A):Value) > ptrValue(_, u32(B):Value)  => ptrValue(null, A >uMInt B)
    rule ptrValue(_, u32(A):Value) < ptrValue(_, u32(B):Value)  => ptrValue(null, A <uMInt B)
    rule ptrValue(_, u32(A):Value) >= ptrValue(_, u32(B):Value)  => ptrValue(null, A >=uMInt B)
    rule ptrValue(_, u32(A):Value) <= ptrValue(_, u32(B):Value)  => ptrValue(null, A <=uMInt B)

    rule ptrValue(_, i64(A):Value)  == ptrValue(_, i64(B):Value)  => ptrValue(null, A ==MInt  B)
    rule ptrValue(_, i64(A):Value)  != ptrValue(_, i64(B):Value)  => ptrValue(null, A =/=MInt B)
    rule ptrValue(_, i64(A):Value)  >  ptrValue(_, i64(B):Value)  => ptrValue(null, A >sMInt  B)
    rule ptrValue(_, i64(A):Value)  <  ptrValue(_, i64(B):Value)  => ptrValue(null, A <sMInt  B)
    rule ptrValue(_, i64(A):Value)  >= ptrValue(_, i64(B):Value)  => ptrValue(null, A >=sMInt B)
    rule ptrValue(_, i64(A):Value)  <= ptrValue(_, i64(B):Value)  => ptrValue(null, A <=sMInt B)

    rule ptrValue(_, u64(A):Value)  == ptrValue(_, u64(B):Value)  => ptrValue(null, A ==MInt  B)
    rule ptrValue(_, u64(A):Value)  != ptrValue(_, u64(B):Value)  => ptrValue(null, A =/=MInt B)
    rule ptrValue(_, u64(A):Value)  >  ptrValue(_, u64(B):Value)  => ptrValue(null, A >uMInt  B)
    rule ptrValue(_, u64(A):Value)  <  ptrValue(_, u64(B):Value)  => ptrValue(null, A <uMInt  B)
    rule ptrValue(_, u64(A):Value)  >= ptrValue(_, u64(B):Value)  => ptrValue(null, A >=uMInt B)
    rule ptrValue(_, u64(A):Value)  <= ptrValue(_, u64(B):Value)  => ptrValue(null, A <=uMInt B)

    rule ptrValue(_, u128(A):Value) == ptrValue(_, u128(B):Value) => ptrValue(null, A ==MInt  B)
    rule ptrValue(_, u128(A):Value) != ptrValue(_, u128(B):Value) => ptrValue(null, A =/=MInt B)
    rule ptrValue(_, u128(A):Value) >  ptrValue(_, u128(B):Value) => ptrValue(null, A >uMInt  B)
    rule ptrValue(_, u128(A):Value) <  ptrValue(_, u128(B):Value) => ptrValue(null, A <uMInt  B)
    rule ptrValue(_, u128(A):Value) >= ptrValue(_, u128(B):Value) => ptrValue(null, A >=uMInt B)
    rule ptrValue(_, u128(A):Value) <= ptrValue(_, u128(B):Value) => ptrValue(null, A <=uMInt B)

endmodule

```
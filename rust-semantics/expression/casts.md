```k

module RUST-CASTS
    imports private RUST-ERROR-SYNTAX
    imports private RUST-REPRESENTATION

    rule implicitCast(V:Value, T:Type) => error("Unknown implicitCast.", ListItem(V) ListItem(T))
        [owise]

    // https://doc.rust-lang.org/stable/reference/expressions/operator-expr.html#numeric-implicitCast

    rule implicitCast(i8(Value), i8 ) => i8 (Value)
    rule implicitCast(i8(Value), u8 ) => u8 (Value)
    rule implicitCast(i8(Value), i16) => i16(Int2MInt(MInt2Signed(Value)))
    rule implicitCast(i8(Value), u16) => u16(Int2MInt(MInt2Signed(Value)))
    rule implicitCast(i8(Value), i32) => i32(Int2MInt(MInt2Unsigned(Value)))
    rule implicitCast(i8(Value), u32) => u32(Int2MInt(MInt2Unsigned(Value)))
    rule implicitCast(i8(Value), i64) => i64(Int2MInt(MInt2Unsigned(Value)))
    rule implicitCast(i8(Value), u64) => u64(Int2MInt(MInt2Unsigned(Value)))

    rule implicitCast(u8(Value), i8 ) => i8 (Value)
    rule implicitCast(u8(Value), u8 ) => u8 (Value)
    rule implicitCast(u8(Value), i16) => i16(Int2MInt(MInt2Signed(Value)))
    rule implicitCast(u8(Value), u16) => u16(Int2MInt(MInt2Signed(Value)))
    rule implicitCast(u8(Value), i32) => i32(Int2MInt(MInt2Unsigned(Value)))
    rule implicitCast(u8(Value), u32) => u32(Int2MInt(MInt2Unsigned(Value)))
    rule implicitCast(u8(Value), i64) => i64(Int2MInt(MInt2Unsigned(Value)))
    rule implicitCast(u8(Value), u64) => u64(Int2MInt(MInt2Unsigned(Value)))

    rule implicitCast(i16(Value), i8 ) => i8 (Int2MInt(MInt2Signed(Value)))
    rule implicitCast(i16(Value), u8 ) => u8 (Int2MInt(MInt2Signed(Value)))
    rule implicitCast(i16(Value), i16) => i16(Value)
    rule implicitCast(i16(Value), u16) => u16(Value)
    rule implicitCast(i16(Value), i32) => i32(Int2MInt(MInt2Unsigned(Value)))
    rule implicitCast(i16(Value), u32) => u32(Int2MInt(MInt2Unsigned(Value)))
    rule implicitCast(i16(Value), i64) => i64(Int2MInt(MInt2Unsigned(Value)))
    rule implicitCast(i16(Value), u64) => u64(Int2MInt(MInt2Unsigned(Value)))

    rule implicitCast(u16(Value), i8 ) => i8 (Int2MInt(MInt2Signed(Value)))
    rule implicitCast(u16(Value), u8 ) => u8 (Int2MInt(MInt2Signed(Value)))
    rule implicitCast(u16(Value), i16) => i16(Value)
    rule implicitCast(u16(Value), u16) => u16(Value)
    rule implicitCast(u16(Value), i32) => i32(Int2MInt(MInt2Unsigned(Value)))
    rule implicitCast(u16(Value), u32) => u32(Int2MInt(MInt2Unsigned(Value)))
    rule implicitCast(u16(Value), i64) => i64(Int2MInt(MInt2Unsigned(Value)))
    rule implicitCast(u16(Value), u64) => u64(Int2MInt(MInt2Unsigned(Value)))

    rule implicitCast(i32(Value), i8 ) => i8 (Int2MInt(MInt2Signed(Value)))
    rule implicitCast(i32(Value), u8 ) => u8 (Int2MInt(MInt2Signed(Value)))
    rule implicitCast(i32(Value), i16) => i16(Int2MInt(MInt2Signed(Value)))
    rule implicitCast(i32(Value), u16) => u16(Int2MInt(MInt2Signed(Value)))
    rule implicitCast(i32(Value), i32) => i32(Value)
    rule implicitCast(i32(Value), u32) => u32(Value)
    rule implicitCast(i32(Value), i64) => i64(Int2MInt(MInt2Signed(Value)))
    rule implicitCast(i32(Value), u64) => u64(Int2MInt(MInt2Signed(Value)))

    rule implicitCast(u32(Value), i8 ) => i8 (Int2MInt(MInt2Signed(Value)))
    rule implicitCast(u32(Value), u8 ) => u8 (Int2MInt(MInt2Signed(Value)))
    rule implicitCast(u32(Value), i16) => i16(Int2MInt(MInt2Signed(Value)))
    rule implicitCast(u32(Value), u16) => u16(Int2MInt(MInt2Signed(Value)))
    rule implicitCast(u32(Value), i32) => i32(Value)
    rule implicitCast(u32(Value), u32) => u32(Value)
    rule implicitCast(u32(Value), i64) => i64(Int2MInt(MInt2Unsigned(Value)))
    rule implicitCast(u32(Value), u64) => u64(Int2MInt(MInt2Unsigned(Value)))


    rule implicitCast(i64(Value), i8 ) => i8 (Int2MInt(MInt2Signed(Value)))
    rule implicitCast(i64(Value), u8 ) => u8 (Int2MInt(MInt2Signed(Value)))
    rule implicitCast(i64(Value), i16) => i16(Int2MInt(MInt2Signed(Value)))
    rule implicitCast(i64(Value), u16) => u16(Int2MInt(MInt2Signed(Value)))
    rule implicitCast(i64(Value), i32) => i32(Int2MInt(MInt2Signed(Value)))
    rule implicitCast(i64(Value), u32) => u32(Int2MInt(MInt2Signed(Value)))
    rule implicitCast(i64(Value), i64) => i64(Value)
    rule implicitCast(i64(Value), u64) => u64(Value)

    rule implicitCast(u64(Value), i8 ) => i8 (Int2MInt(MInt2Signed(Value)))
    rule implicitCast(u64(Value), u8 ) => u8 (Int2MInt(MInt2Signed(Value)))
    rule implicitCast(u64(Value), i16) => i16(Int2MInt(MInt2Signed(Value)))
    rule implicitCast(u64(Value), u16) => u16(Int2MInt(MInt2Signed(Value)))
    rule implicitCast(u64(Value), i32) => i32(Int2MInt(MInt2Unsigned(Value)))
    rule implicitCast(u64(Value), u32) => u32(Int2MInt(MInt2Unsigned(Value)))
    rule implicitCast(u64(Value), i64) => i64(Value)
    rule implicitCast(u64(Value), u64) => u64(Value)

    rule implicitCast(u128(Value), i8 ) => i8 (Int2MInt(MInt2Signed(Value)))
    rule implicitCast(u128(Value), u8 ) => u8 (Int2MInt(MInt2Signed(Value)))
    rule implicitCast(u128(Value), i16) => i16(Int2MInt(MInt2Signed(Value)))
    rule implicitCast(u128(Value), u16) => u16(Int2MInt(MInt2Signed(Value)))
    rule implicitCast(u128(Value), i32) => i32(Int2MInt(MInt2Unsigned(Value)))
    rule implicitCast(u128(Value), u32) => u32(Int2MInt(MInt2Unsigned(Value)))
    rule implicitCast(u128(Value), i64) => i64(Int2MInt(MInt2Unsigned(Value)))
    rule implicitCast(u128(Value), u64) => u64(Int2MInt(MInt2Unsigned(Value)))

    rule implicitCast(V:Bool, bool) => V
    rule implicitCast(S:String, str) => S

    rule implicitCast(tuple(.ValueList) #as V, ():Type) => V
    rule implicitCast(tuple(Vs:ValueList), (Ts:NonEmptyTypeCsv))
        => tupleOrError(implicitCastList(Vs, Ts))

    rule implicitCast(struct(T, _) #as V, T) => V
    rule implicitCast(struct(T, _) #as V, T < _ >) => V

    // Rewrites

    rule ptrValue(P:Ptr, V:Value) ~> implicitCastTo(T:Type) => wrapPtrValueOrError(P, implicitCast(V, T))
    // We don't need a value for the unit type
    rule implicitCastTo(( )) => .K

    syntax ValueListOrError ::= implicitCastList(ValueList, NonEmptyTypeCsv)  [function, total]
    rule implicitCastList(V:Value , .ValueList, T:Type) => concat(implicitCast(V, T), .ValueList)
    rule implicitCastList(V:Value , Vs:ValueList, T:Type, Ts:NonEmptyTypeCsv)
        => concat(implicitCast(V, T), implicitCastList(Vs, Ts))
    rule implicitCastList(Vs:ValueList, Ts:NonEmptyTypeCsv)
        => error("implicitCastList values not paired with types", ListItem(Vs) ListItem(Ts))
        [owise]

endmodule

```

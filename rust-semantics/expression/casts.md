```k

module RUST-CASTS
    imports private RUST-ERROR-SYNTAX
    imports private RUST-REPRESENTATION

    rule implicitCast(V:Value, T:Type) => error("Unknown implicitCast.", ListItem(V) ListItem(T))
        [owise]

    // https://doc.rust-lang.org/stable/reference/expressions/operator-expr.html#numeric-cast

    syntax ValueOrError ::= implicitCast(Int, Type)  [function, total]
    rule implicitCast(Value:Int, T:Type)
        => error("implicitCast(Int, Type)", ListItem(Value) ListItem(T))
        [owise]
    rule implicitCast(Value:Int, i8  ) => i8  (Int2MInt(Value))
    rule implicitCast(Value:Int, u8  ) => u8  (Int2MInt(Value))
    rule implicitCast(Value:Int, i16 ) => i16 (Int2MInt(Value))
    rule implicitCast(Value:Int, u16 ) => u16 (Int2MInt(Value))
    rule implicitCast(Value:Int, i32 ) => i32 (Int2MInt(Value))
    rule implicitCast(Value:Int, u32 ) => u32 (Int2MInt(Value))
    rule implicitCast(Value:Int, i64 ) => i64 (Int2MInt(Value))
    rule implicitCast(Value:Int, u64 ) => u64 (Int2MInt(Value))
    rule implicitCast(Value:Int, u128) => u128(Int2MInt(Value))
    rule implicitCast(Value:Int, u160) => u160(Int2MInt(Value))
    rule implicitCast(Value:Int, u256) => u256(Int2MInt(Value))

    rule implicitCast(i8  (Value), T:Type ) => implicitCast(MInt2Signed(Value), T)
    rule implicitCast(u8  (Value), T:Type ) => implicitCast(MInt2Unsigned(Value), T)
    rule implicitCast(i16 (Value), T:Type ) => implicitCast(MInt2Signed(Value), T)
    rule implicitCast(u16 (Value), T:Type ) => implicitCast(MInt2Unsigned(Value), T)
    rule implicitCast(i32 (Value), T:Type ) => implicitCast(MInt2Signed(Value), T)
    rule implicitCast(u32 (Value), T:Type ) => implicitCast(MInt2Unsigned(Value), T)
    rule implicitCast(i64 (Value), T:Type ) => implicitCast(MInt2Signed(Value), T)
    rule implicitCast(u64 (Value), T:Type ) => implicitCast(MInt2Unsigned(Value), T)
    rule implicitCast(u128(Value), T:Type ) => implicitCast(MInt2Unsigned(Value), T)
    rule implicitCast(u160(Value), T:Type ) => implicitCast(MInt2Unsigned(Value), T)
    rule implicitCast(u256(Value), T:Type ) => implicitCast(MInt2Unsigned(Value), T)

    rule implicitCast(V:Bool, bool) => V
    rule implicitCast(S:String, str) => S

    rule implicitCast(tuple(.ValueList) #as V, ():Type) => V
    rule implicitCast(tuple(Vs:ValueList), (Ts:NonEmptyTypeCsv))
        => tupleOrError(implicitCastList(Vs, Ts))

    rule implicitCast(struct(T, _) #as V, T) => V
    rule implicitCast(struct(T, _) #as V, T < _ >) => V
    rule implicitCast(struct(:: A :: T, _) #as V, :: A :: T < _ >) => V

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

```k

module RUST-CASTS
    imports private RUST-REPRESENTATION

    syntax ValueOrError ::= implicitCast(Value, Type)  [function, total]

    rule implicitCast(V:Value, T:Type) => error("Unknown implicitCast.", ListItem(V) ListItem(T))
        [owise]

    // https://doc.rust-lang.org/stable/reference/expressions/operator-expr.html#numeric-implicitCast

    rule implicitCast(i32(Value), i32) => i32(Value)
    rule implicitCast(i32(Value), u32) => u32(Value)
    rule implicitCast(i32(Value), i64) => i64(Int2MInt(MInt2Signed(Value)))
    rule implicitCast(i32(Value), u64) => u64(Int2MInt(MInt2Signed(Value)))

    rule implicitCast(u32(Value), i32) => i32(Value)
    rule implicitCast(u32(Value), u32) => u32(Value)
    rule implicitCast(u32(Value), i64) => i64(Int2MInt(MInt2Unsigned(Value)))
    rule implicitCast(u32(Value), u64) => u64(Int2MInt(MInt2Unsigned(Value)))


    rule implicitCast(i64(Value), i32) => i32(Int2MInt(MInt2Signed(Value)))
    rule implicitCast(i64(Value), u32) => u32(Int2MInt(MInt2Signed(Value)))
    rule implicitCast(i64(Value), i64) => i64(Value)
    rule implicitCast(i64(Value), u64) => u64(Value)

    rule implicitCast(u64(Value), i32) => i32(Int2MInt(MInt2Unsigned(Value)))
    rule implicitCast(u64(Value), u32) => u32(Int2MInt(MInt2Unsigned(Value)))
    rule implicitCast(u64(Value), i64) => i64(Value)
    rule implicitCast(u64(Value), u64) => u64(Value)

    rule implicitCast(u128(Value), i32) => i32(Int2MInt(MInt2Unsigned(Value)))
    rule implicitCast(u128(Value), u32) => u32(Int2MInt(MInt2Unsigned(Value)))
    rule implicitCast(u128(Value), i64) => i64(Int2MInt(MInt2Unsigned(Value)))
    rule implicitCast(u128(Value), u64) => u64(Int2MInt(MInt2Unsigned(Value)))

    rule implicitCast(V:Bool, bool) => V

    rule implicitCast(tuple(.ValueList) #as V, ():Type) => V

    rule implicitCast(struct(T, _) #as V, T) => V
    rule implicitCast(struct(T, _) #as V, T < _ >) => V

    // Rewrites

    rule ptrValue(P:Ptr, V:Value) ~> implicitCastTo(T:Type) => wrapPtrValueOrError(P, implicitCast(V, T))
    // We don't need a value for the unit type
    rule implicitCastTo(( )) => .K

endmodule

```

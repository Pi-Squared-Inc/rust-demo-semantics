```k

module RUST-CASTS
    imports private RUST-REPRESENTATION

    syntax ValueOrError ::= cast(Value, Type)  [function, total]

    rule cast(V:Value, T:Type) => error("Unknown cast.", ListItem(V) ListItem(T))
        [owise]

    // https://doc.rust-lang.org/stable/reference/expressions/operator-expr.html#numeric-cast

    rule cast(i32(Value), i32) => i32(Value)
    rule cast(i32(Value), u32) => u32(Value)
    rule cast(i32(Value), i64) => i64(Int2MInt(MInt2Signed(Value)))
    rule cast(i32(Value), u64) => u64(Int2MInt(MInt2Signed(Value)))

    rule cast(u32(Value), i32) => i32(Value)
    rule cast(u32(Value), u32) => u32(Value)
    rule cast(u32(Value), i64) => i64(Int2MInt(MInt2Unsigned(Value)))
    rule cast(u32(Value), u64) => u64(Int2MInt(MInt2Unsigned(Value)))


    rule cast(i64(Value), i32) => i32(Int2MInt(MInt2Signed(Value)))
    rule cast(i64(Value), u32) => u32(Int2MInt(MInt2Signed(Value)))
    rule cast(i64(Value), i64) => i64(Value)
    rule cast(i64(Value), u64) => u64(Value)

    rule cast(u64(Value), i32) => i32(Int2MInt(MInt2Unsigned(Value)))
    rule cast(u64(Value), u32) => u32(Int2MInt(MInt2Unsigned(Value)))
    rule cast(u64(Value), i64) => i64(Value)
    rule cast(u64(Value), u64) => u64(Value)

    rule cast(u128(Value), i32) => i32(Int2MInt(MInt2Unsigned(Value)))
    rule cast(u128(Value), u32) => u32(Int2MInt(MInt2Unsigned(Value)))
    rule cast(u128(Value), i64) => i64(Int2MInt(MInt2Unsigned(Value)))
    rule cast(u128(Value), u64) => u64(Int2MInt(MInt2Unsigned(Value)))

    // Rewrites

    rule V:Value ~> castTo(T:Type) => cast(V, T)
    // We don't need a value for the unit type
    rule castTo(( )) => .K

endmodule

```

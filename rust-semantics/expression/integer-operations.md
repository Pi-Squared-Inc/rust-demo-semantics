```k

module RUST-INTEGER-OPERATIONS
    imports private RUST-INTEGER-ARITHMETIC-OPERATIONS
    imports private RUST-INTEGER-RANGE-OPERATIONS
endmodule

module RUST-INTEGER-ARITHMETIC-OPERATIONS
    imports private K-EQUAL-SYNTAX
    imports private RUST-SHARED-SYNTAX
    imports private RUST-REPRESENTATION

    // Operations are implemented only for the same types, 
    // as implicit type casting (coercion) is not available
    // in Rust.

    rule ptrValue(_, i8(A):Value) * ptrValue(_, i8(B):Value) => ptrValue(null, i8(A *MInt B))
    rule ptrValue(_, i8(A):Value) + ptrValue(_, i8(B):Value) => ptrValue(null, i8(A +MInt B))
    rule ptrValue(_, i8(A):Value) - ptrValue(_, i8(B):Value) => ptrValue(null, i8(A -MInt B))
    rule ptrValue(_, i8(A):Value) / ptrValue(_, i8(B):Value) => ptrValue(null, i8(A /sMInt B))
        requires B =/=K 0p8
    rule ptrValue(_, i8(A):Value) % ptrValue(_, i8(B):Value) => ptrValue(null, i8(A %sMInt B))
        requires B =/=K 0p8

    rule ptrValue(_, u8(A):Value) * ptrValue(_, u8(B):Value) => ptrValue(null, u8(A *MInt B))
    rule ptrValue(_, u8(A):Value) + ptrValue(_, u8(B):Value) => ptrValue(null, u8(A +MInt B))
    rule ptrValue(_, u8(A):Value) - ptrValue(_, u8(B):Value) => ptrValue(null, u8(A -MInt B))
    rule ptrValue(_, u8(A):Value) / ptrValue(_, u8(B):Value) => ptrValue(null, u8(A /sMInt B))
        requires B =/=K 0p8
    rule ptrValue(_, u8(A):Value) % ptrValue(_, u8(B):Value) => ptrValue(null, u8(A %sMInt B))
        requires B =/=K 0p8

    rule ptrValue(_, i16(A):Value) * ptrValue(_, i16(B):Value) => ptrValue(null, i16(A *MInt B))
    rule ptrValue(_, i16(A):Value) + ptrValue(_, i16(B):Value) => ptrValue(null, i16(A +MInt B))
    rule ptrValue(_, i16(A):Value) - ptrValue(_, i16(B):Value) => ptrValue(null, i16(A -MInt B))
    rule ptrValue(_, i16(A):Value) / ptrValue(_, i16(B):Value) => ptrValue(null, i16(A /sMInt B))
        requires B =/=K 0p16
    rule ptrValue(_, i16(A):Value) % ptrValue(_, i16(B):Value) => ptrValue(null, i16(A %sMInt B))
        requires B =/=K 0p16

    rule ptrValue(_, u16(A):Value) * ptrValue(_, u16(B):Value) => ptrValue(null, u16(A *MInt B))
    rule ptrValue(_, u16(A):Value) + ptrValue(_, u16(B):Value) => ptrValue(null, u16(A +MInt B))
    rule ptrValue(_, u16(A):Value) - ptrValue(_, u16(B):Value) => ptrValue(null, u16(A -MInt B))
    rule ptrValue(_, u16(A):Value) / ptrValue(_, u16(B):Value) => ptrValue(null, u16(A /sMInt B))
        requires B =/=K 0p16
    rule ptrValue(_, u16(A):Value) % ptrValue(_, u16(B):Value) => ptrValue(null, u16(A %sMInt B))
        requires B =/=K 0p16

    rule ptrValue(_, i32(A):Value) * ptrValue(_, i32(B):Value) => ptrValue(null, i32(A *MInt B))
    rule ptrValue(_, i32(A):Value) + ptrValue(_, i32(B):Value) => ptrValue(null, i32(A +MInt B))
    rule ptrValue(_, i32(A):Value) - ptrValue(_, i32(B):Value) => ptrValue(null, i32(A -MInt B))
    rule ptrValue(_, i32(A):Value) / ptrValue(_, i32(B):Value) => ptrValue(null, i32(A /sMInt B))
        requires B =/=K 0p32
    rule ptrValue(_, i32(A):Value) % ptrValue(_, i32(B):Value) => ptrValue(null, i32(A %sMInt B))
        requires B =/=K 0p32

    rule ptrValue(_, u32(A):Value) * ptrValue(_, u32(B):Value) => ptrValue(null, u32(A *MInt B))
    rule ptrValue(_, u32(A):Value) + ptrValue(_, u32(B):Value) => ptrValue(null, u32(A +MInt B))
    rule ptrValue(_, u32(A):Value) - ptrValue(_, u32(B):Value) => ptrValue(null, u32(A -MInt B))
    rule ptrValue(_, u32(A):Value) / ptrValue(_, u32(B):Value) => ptrValue(null, u32(A /uMInt B))
        requires B =/=K 0p32
    rule ptrValue(_, u32(A):Value) % ptrValue(_, u32(B):Value) => ptrValue(null, u32(A %uMInt B))
        requires B =/=K 0p32

    rule ptrValue(_, i64(A):Value) * ptrValue(_, i64(B):Value) => ptrValue(null, i64(A *MInt B))
    rule ptrValue(_, i64(A):Value) + ptrValue(_, i64(B):Value) => ptrValue(null, i64(A +MInt B))
    rule ptrValue(_, i64(A):Value) - ptrValue(_, i64(B):Value) => ptrValue(null, i64(A -MInt B))
    rule ptrValue(_, i64(A):Value) / ptrValue(_, i64(B):Value) => ptrValue(null, i64(A /sMInt B))
        requires B =/=K 0p64
    rule ptrValue(_, i64(A):Value) % ptrValue(_, i64(B):Value) => ptrValue(null, i64(A %sMInt B))
        requires B =/=K 0p64
    
    rule ptrValue(_, u64(A):Value) * ptrValue(_, u64(B):Value) => ptrValue(null, u64(A *MInt B))
    rule ptrValue(_, u64(A):Value) + ptrValue(_, u64(B):Value) => ptrValue(null, u64(A +MInt B))
    rule ptrValue(_, u64(A):Value) - ptrValue(_, u64(B):Value) => ptrValue(null, u64(A -MInt B))
    rule ptrValue(_, u64(A):Value) / ptrValue(_, u64(B):Value) => ptrValue(null, u64(A /uMInt B))
        requires B =/=K 0p64
    rule ptrValue(_, u64(A):Value) % ptrValue(_, u64(B):Value) => ptrValue(null, u64(A %uMInt B))
        requires B =/=K 0p64

    rule ptrValue(_, u128(A):Value) * ptrValue(_, u128(B):Value) => ptrValue(null, u128(A *MInt B))
    rule ptrValue(_, u128(A):Value) + ptrValue(_, u128(B):Value) => ptrValue(null, u128(A +MInt B))
    rule ptrValue(_, u128(A):Value) - ptrValue(_, u128(B):Value) => ptrValue(null, u128(A -MInt B))
    rule ptrValue(_, u128(A):Value) / ptrValue(_, u128(B):Value) => ptrValue(null, u128(A /uMInt B))
        requires B =/=K 0p128
    rule ptrValue(_, u128(A):Value) % ptrValue(_, u128(B):Value) => ptrValue(null, u128(A %uMInt B))
        requires B =/=K 0p128

    rule ptrValue(_, u160(A):Value) * ptrValue(_, u160(B):Value) => ptrValue(null, u160(A *MInt B))
    rule ptrValue(_, u160(A):Value) + ptrValue(_, u160(B):Value) => ptrValue(null, u160(A +MInt B))
    rule ptrValue(_, u160(A):Value) - ptrValue(_, u160(B):Value) => ptrValue(null, u160(A -MInt B))
    rule ptrValue(_, u160(A):Value) / ptrValue(_, u160(B):Value) => ptrValue(null, u160(A /uMInt B))
        requires B =/=K 0p160
    rule ptrValue(_, u160(A):Value) % ptrValue(_, u160(B):Value) => ptrValue(null, u160(A %uMInt B))
        requires B =/=K 0p160

    rule ptrValue(_, u256(A):Value) * ptrValue(_, u256(B):Value) => ptrValue(null, u256(A *MInt B))
    rule ptrValue(_, u256(A):Value) + ptrValue(_, u256(B):Value) => ptrValue(null, u256(A +MInt B))
    rule ptrValue(_, u256(A):Value) - ptrValue(_, u256(B):Value) => ptrValue(null, u256(A -MInt B))
    rule ptrValue(_, u256(A):Value) / ptrValue(_, u256(B):Value) => ptrValue(null, u256(A /uMInt B))
        requires B =/=K 0p256
    rule ptrValue(_, u256(A):Value) % ptrValue(_, u256(B):Value) => ptrValue(null, u256(A %uMInt B))
        requires B =/=K 0p256

endmodule


module RUST-INTEGER-RANGE-OPERATIONS
    imports RUST-SHARED-SYNTAX
    imports private RUST-REPRESENTATION

    rule (ptrValue(_, i8 (A):Value) .. ptrValue(_, i8 (B):Value)):Expression => ptrValue(null, intRange(i8 (A), i8 (B)))
    rule (ptrValue(_, u8 (A):Value) .. ptrValue(_, u8 (B):Value)):Expression => ptrValue(null, intRange(u8 (A), u8 (B)))
    rule (ptrValue(_, i16(A):Value) .. ptrValue(_, i16(B):Value)):Expression => ptrValue(null, intRange(i16(A), i16(B)))
    rule (ptrValue(_, u16(A):Value) .. ptrValue(_, u16(B):Value)):Expression => ptrValue(null, intRange(u16(A), u16(B)))
    rule (ptrValue(_, i32(A):Value) .. ptrValue(_, i32(B):Value)):Expression => ptrValue(null, intRange(i32(A), i32(B)))
    rule (ptrValue(_, u32(A):Value) .. ptrValue(_, u32(B):Value)):Expression => ptrValue(null, intRange(u32(A), u32(B)))
    rule (ptrValue(_, i64(A):Value) .. ptrValue(_, i64(B):Value)):Expression => ptrValue(null, intRange(i64(A), i64(B)))
    rule (ptrValue(_, u64(A):Value) .. ptrValue(_, u64(B):Value)):Expression => ptrValue(null, intRange(u64(A), u64(B)))
    rule (ptrValue(_, u128(A):Value) .. ptrValue(_, u128(B):Value)):Expression => ptrValue(null, intRange(u128(A), u128(B)))
    rule (ptrValue(_, u160(A):Value) .. ptrValue(_, u160(B):Value)):Expression => ptrValue(null, intRange(u160(A), u160(B)))
    rule (ptrValue(_, u256(A):Value) .. ptrValue(_, u256(B):Value)):Expression => ptrValue(null, intRange(u256(A), u256(B)))

endmodule

```

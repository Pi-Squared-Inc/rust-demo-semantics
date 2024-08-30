```k

module RUST-INTEGER-ARITHMETIC-OPERATIONS
    imports RUST-SHARED-SYNTAX
    imports private RUST-REPRESENTATION

    // Operations are implemented only for the same types, 
    // as implicit type casting (coercion) is not available
    // in Rust.

    rule i32(A):Value * i32(B):Value => i32(A *MInt B)
    rule i32(A):Value + i32(B):Value => i32(A +MInt B)
    rule i32(A):Value - i32(B):Value => i32(A -MInt B)
    rule i32(A):Value / i32(B):Value => i32(A /sMInt B)
    rule i32(A):Value % i32(B):Value => i32(A %sMInt B)
    
    rule u32(A):Value * u32(B):Value => u32(A *MInt B)
    rule u32(A):Value + u32(B):Value => u32(A +MInt B)
    rule u32(A):Value - u32(B):Value => u32(A -MInt B)
    rule u32(A):Value / u32(B):Value => u32(A /uMInt B)
    rule u32(A):Value % u32(B):Value => u32(A %uMInt B)

    rule i64(A):Value * i64(B):Value => i64(A *MInt B)
    rule i64(A):Value + i64(B):Value => i64(A +MInt B)
    rule i64(A):Value - i64(B):Value => i64(A -MInt B)
    rule i64(A):Value / i64(B):Value => i64(A /sMInt B)
    rule i64(A):Value % i64(B):Value => i64(A %sMInt B)
    
    rule u64(A):Value * u64(B):Value => u64(A *MInt B)
    rule u64(A):Value + u64(B):Value => u64(A +MInt B)
    rule u64(A):Value - u64(B):Value => u64(A -MInt B)
    rule u64(A):Value / u64(B):Value => u64(A /uMInt B)
    rule u64(A):Value % u64(B):Value => u64(A %uMInt B)

    rule u128(A):Value * u128(B):Value => u128(A *MInt B)
    rule u128(A):Value + u128(B):Value => u128(A +MInt B)
    rule u128(A):Value - u128(B):Value => u128(A -MInt B)
    rule u128(A):Value / u128(B):Value => u128(A /uMInt B)
    rule u128(A):Value % u128(B):Value => u128(A %uMInt B)
endmodule

```

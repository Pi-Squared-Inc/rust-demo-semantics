```k

module RUST-INTEGER-OPERATIONS
    imports private RUST-INTEGER-ARITHMETIC-OPERATIONS
    imports private RUST-INTEGER-RELATIONAL-OPERATIONS
endmodule

module RUST-INTEGER-ARITHMETIC-OPERATIONS
    imports RUST-SHARED-SYNTAX
    imports private RUST-REPRESENTATION

    // Operations are implemented only for the same types, 
    // as implicit type casting (coercion) is not available
    // in Rust.

    rule ptrValue(_, i32(A):Value) * ptrValue(_, i32(B):Value) => ptrValue(null, i32(A *MInt B))
    rule ptrValue(_, i32(A):Value) + ptrValue(_, i32(B):Value) => ptrValue(null, i32(A +MInt B))
    rule ptrValue(_, i32(A):Value) - ptrValue(_, i32(B):Value) => ptrValue(null, i32(A -MInt B))
    rule ptrValue(_, i32(A):Value) / ptrValue(_, i32(B):Value) => ptrValue(null, i32(A /sMInt B))
    rule ptrValue(_, i32(A):Value) % ptrValue(_, i32(B):Value) => ptrValue(null, i32(A %sMInt B))
    
    rule ptrValue(_, u32(A):Value) * ptrValue(_, u32(B):Value) => ptrValue(null, u32(A *MInt B))
    rule ptrValue(_, u32(A):Value) + ptrValue(_, u32(B):Value) => ptrValue(null, u32(A +MInt B))
    rule ptrValue(_, u32(A):Value) - ptrValue(_, u32(B):Value) => ptrValue(null, u32(A -MInt B))
    rule ptrValue(_, u32(A):Value) / ptrValue(_, u32(B):Value) => ptrValue(null, u32(A /uMInt B))
    rule ptrValue(_, u32(A):Value) % ptrValue(_, u32(B):Value) => ptrValue(null, u32(A %uMInt B))

    rule ptrValue(_, i64(A):Value) * ptrValue(_, i64(B):Value) => ptrValue(null, i64(A *MInt B))
    rule ptrValue(_, i64(A):Value) + ptrValue(_, i64(B):Value) => ptrValue(null, i64(A +MInt B))
    rule ptrValue(_, i64(A):Value) - ptrValue(_, i64(B):Value) => ptrValue(null, i64(A -MInt B))
    rule ptrValue(_, i64(A):Value) / ptrValue(_, i64(B):Value) => ptrValue(null, i64(A /sMInt B))
    rule ptrValue(_, i64(A):Value) % ptrValue(_, i64(B):Value) => ptrValue(null, i64(A %sMInt B))
    
    rule ptrValue(_, u64(A):Value) * ptrValue(_, u64(B):Value) => ptrValue(null, u64(A *MInt B))
    rule ptrValue(_, u64(A):Value) + ptrValue(_, u64(B):Value) => ptrValue(null, u64(A +MInt B))
    rule ptrValue(_, u64(A):Value) - ptrValue(_, u64(B):Value) => ptrValue(null, u64(A -MInt B))
    rule ptrValue(_, u64(A):Value) / ptrValue(_, u64(B):Value) => ptrValue(null, u64(A /uMInt B))
    rule ptrValue(_, u64(A):Value) % ptrValue(_, u64(B):Value) => ptrValue(null, u64(A %uMInt B))

    rule ptrValue(_, u128(A):Value) * ptrValue(_, u128(B):Value) => ptrValue(null, u128(A *MInt B))
    rule ptrValue(_, u128(A):Value) + ptrValue(_, u128(B):Value) => ptrValue(null, u128(A +MInt B))
    rule ptrValue(_, u128(A):Value) - ptrValue(_, u128(B):Value) => ptrValue(null, u128(A -MInt B))
    rule ptrValue(_, u128(A):Value) / ptrValue(_, u128(B):Value) => ptrValue(null, u128(A /uMInt B))
    rule ptrValue(_, u128(A):Value) % ptrValue(_, u128(B):Value) => ptrValue(null, u128(A %uMInt B))

endmodule


module RUST-INTEGER-RELATIONAL-OPERATIONS
    imports RUST-SHARED-SYNTAX
    imports private RUST-REPRESENTATION

    rule ptrValue(null, i32(A):Value)  == ptrValue(null, i32(B):Value)  => ptrValue(null, A ==MInt  B)
    rule ptrValue(null, i32(A):Value)  != ptrValue(null, i32(B):Value)  => ptrValue(null, A =/=MInt B)
    rule ptrValue(null, i32(A):Value)  >  ptrValue(null, i32(B):Value)  => ptrValue(null, A >sMInt  B)
    rule ptrValue(null, i32(A):Value)  <  ptrValue(null, i32(B):Value)  => ptrValue(null, A <sMInt  B)
    rule ptrValue(null, i32(A):Value)  >= ptrValue(null, i32(B):Value)  => ptrValue(null, A >=sMInt B)
    rule ptrValue(null, i32(A):Value)  <= ptrValue(null, i32(B):Value)  => ptrValue(null, A <=sMInt B)

    rule ptrValue(null, u32(A):Value) == ptrValue(null, u32(B):Value)  => ptrValue(null, A ==MInt B)
    rule ptrValue(null, u32(A):Value) != ptrValue(null, u32(B):Value)  => ptrValue(null, A =/=MInt B)
    rule ptrValue(null, u32(A):Value) > ptrValue(null, u32(B):Value)  => ptrValue(null, A >uMInt B)
    rule ptrValue(null, u32(A):Value) < ptrValue(null, u32(B):Value)  => ptrValue(null, A <uMInt B)
    rule ptrValue(null, u32(A):Value) >= ptrValue(null, u32(B):Value)  => ptrValue(null, A >=uMInt B)
    rule ptrValue(null, u32(A):Value) <= ptrValue(null, u32(B):Value)  => ptrValue(null, A <=uMInt B)

    rule ptrValue(null, i64(A):Value)  == ptrValue(null, i64(B):Value)  => ptrValue(null, A ==MInt  B)
    rule ptrValue(null, i64(A):Value)  != ptrValue(null, i64(B):Value)  => ptrValue(null, A =/=MInt B)
    rule ptrValue(null, i64(A):Value)  >  ptrValue(null, i64(B):Value)  => ptrValue(null, A >sMInt  B)
    rule ptrValue(null, i64(A):Value)  <  ptrValue(null, i64(B):Value)  => ptrValue(null, A <sMInt  B)
    rule ptrValue(null, i64(A):Value)  >= ptrValue(null, i64(B):Value)  => ptrValue(null, A >=sMInt B)
    rule ptrValue(null, i64(A):Value)  <= ptrValue(null, i64(B):Value)  => ptrValue(null, A <=sMInt B)

    rule ptrValue(null, u64(A):Value)  == ptrValue(null, u64(B):Value)  => ptrValue(null, A ==MInt  B)
    rule ptrValue(null, u64(A):Value)  != ptrValue(null, u64(B):Value)  => ptrValue(null, A =/=MInt B)
    rule ptrValue(null, u64(A):Value)  >  ptrValue(null, u64(B):Value)  => ptrValue(null, A >uMInt  B)
    rule ptrValue(null, u64(A):Value)  <  ptrValue(null, u64(B):Value)  => ptrValue(null, A <uMInt  B)
    rule ptrValue(null, u64(A):Value)  >= ptrValue(null, u64(B):Value)  => ptrValue(null, A >=uMInt B)
    rule ptrValue(null, u64(A):Value)  <= ptrValue(null, u64(B):Value)  => ptrValue(null, A <=uMInt B)

    rule ptrValue(null, u128(A):Value) == ptrValue(null, u128(B):Value) => ptrValue(null, A ==MInt  B)
    rule ptrValue(null, u128(A):Value) != ptrValue(null, u128(B):Value) => ptrValue(null, A =/=MInt B)
    rule ptrValue(null, u128(A):Value) >  ptrValue(null, u128(B):Value) => ptrValue(null, A >uMInt  B)
    rule ptrValue(null, u128(A):Value) <  ptrValue(null, u128(B):Value) => ptrValue(null, A <uMInt  B)
    rule ptrValue(null, u128(A):Value) >= ptrValue(null, u128(B):Value) => ptrValue(null, A >=uMInt B)
    rule ptrValue(null, u128(A):Value) <= ptrValue(null, u128(B):Value) => ptrValue(null, A <=uMInt B)

endmodule

```
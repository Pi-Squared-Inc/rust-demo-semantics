Rust Demo Semantics
===================

This is a semantics for a subset of Rust + and a subset of the MultiversX
extensions that is easy to implement.

As an example, a lot of Rust features are not supported, or are supported
only for parsing (e.g., structs, inheritance, modules, imports).
Also, this semantics relies on top-level traits being annotated with
#[multiversx_sc::contract], and allows calls to methods declared in these
traits.

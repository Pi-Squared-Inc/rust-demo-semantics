Rust Demo Semantics
===================

This is a semantics for a subset of Rust + and a subset of the MultiversX
extensions that is easy to implement.

As an example, a lot of Rust features are not supported, or have limited support
(e.g., structs, inheritance, modules, imports).
Also, this semantics relies on top-level traits being annotated with
`#[ulm::contract]`, and allows calls to methods declared in these
traits.

Setup for ULM
-------------

You must have `ulm` and `evm-semantics` checked out as sibling directories
(i.e. `../ulm` and `../evm-semantics`).

Build the semantics:
```
make build-ulm -j3
```

Preprocess and convert a contract to bytes:
```
compilation/prepare-contract.sh \
    tests/ulm-contracts/erc_20_token.rs \
    .build/compilation/erc_20_token.preprocessed.kore
```

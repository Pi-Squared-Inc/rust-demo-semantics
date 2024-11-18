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

The commands below will not work without the encode/decode ULM hooks,
which are not included by the build commands below.

"Compiling" the erc-20 contract to bytes:

```sh
make .build/ulm-preprocessing-kompiled/timestamp
compilation/prepare-erc20.sh
```

The above will produce a cell containing the full preprocessed contract.

Running the contract requires a different semantics (there main difference from
the above is the setup of the `<k>` cell; there are other small differences, but
they matter less):

```sh
make .build/ulm-execution-kompiled/timestamp
```
When running the above (say, with `krun`), and calling the constructor
(`$CREATE` is `true`), it expects `CallData()` to contain the initial quantity
to mint and assign to the caller (`u256`). At the end, it will leave the
contract's bytes in the `<k>` cell in a similar way to the `SIMPLE-ulm` example.

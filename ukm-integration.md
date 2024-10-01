UKM Integration Design
======================

The main restriction for the Rust semantics is that we can't declare structs
and we can't implement traits. While we could add those, it is non-trivial,
and we will try to avoid this. In general, we will try to avoid adding
non-trivial features to the Rust-lite implementation.

However, note that we can "declare" structs in K, and they will work properly in
the current rust semantics. Also, for Mx we are loading traits as contracts
(in the actual Mx world they use macros to create the actual contract from the
trait, but we are skipping that).

As with the Mx semantics, we are going to keep the Rust semantics as a pure Rust
semnatics, and we are going to have a second semantics that will add the
blockchain features.

Contracts
---------

As for Mx, contracts will be traits, identified by an attribute
(`#[ethereum::contract]`). Endpoints will be non-static functions if this trait
identified by something like `#[endpoint(endpointName)]`. Storage will be
defined as non-static unimplemented functions identified by
`#[storage("storage_name")]`, e.g.:

```rs
    #[storage("total_supply")]
    fn s_total_supply(&self, key: &u64) -> Storage<u64>;
```

This representation will allow us to kind of reuse some Mx code.

Storage
-------

A storage key is the hash of the storage's name concatenated with the arguments
passed to the storage function (except self). To avoid ambiguities
(e.g. a storage called "a" with an argument "bc" should be different from
a storage called "ab" with "c" as argument), we will encode these using (say) RLP.

This representation will allow us to kind of reuse some Mx code.

Contract calls
--------------

For each contract we will define some helper functions implementing call
functionality. Initially these will be written in K,
but at some point we should use attributes like `#[ethereum::contract]` to
generate actual Rust code.

We will have a function called `Contract#call` that decodes the function's
hash from the request, matches it against the hashes of the endpoints, then
calls the endpoint's wrapper

For each endpoint, we will have a function called `Contract#endpoint#<endpointName>`.
This will decode the endpoint's arguments, passing them to the endpoint. It will
also take the endpoint's return value, it will encode it and it will store it
in the configuration (there will be an internal hook for that).

UKM Hooks
---------

A contract trait will have a special function
`fn blockchain_hooks(self) -> BlockchainHooks;`.
This function is defined automatically by the semantics. The `BlockchainHooks`
trait, also defined automatically by the semantics, will provide functions
which call the hooks directly, e.g. it will have a function
```rs
fn GetAccountBalance(&self, acct: &Int160) -> Int256;
```
that translates directly to a call to
```k
syntax Int ::= GetAccountBalance(acct: Int) [function, hook(UKM.getBalance), total]
```

Internal Hooks
--------------

A contract trait will have a special function
`fn internal_hooks(self) -> InternalHooks;` which will return an object with
which to access the internal configuration, similar to `BlockchainHooks`.

Int Types
---------

Rust has native int types up to 128 bytes. However, we will need int values
with 160 and 256 bytes. We don't want to implement structs. We could implement
them as tuples, but that's confusing. Also, we don't want to implement traits.

One option would be to hold the actual int256 values in the configuration, in
a `Map` from `Int` to `MInt{256}` or something similar. Their Rust
representation would be a K-defined struct which just holds the int ID.
Instead of implementing traits for operators (e.g. `std::ops::Add`), we would
handle the operators manually, translating them to internal hooks.

Another option would be to use K-defined structs for Int256, the struct holding
4 int64 values. We would still need to implement the operators in K, but
we could translate them to calls to Rust functions (also see the
[Helper functions](#helper-functions) section).

I prefer the second option, which seems cleaner, but may require somewhat
more work.

All functions in `BlockchainHooks` that take Ints as arguments will take whatever
representation we choose from the above.

Bytes encoding/decoding for values
----------------------------------

At least two places require encoding values as bytes: storage access and contract
calls. As above, we have two options: implement bytes operations in Rust, and
keep bytes in a Map from Id:Int to Bytes in the configuration, and provide
access through hooks.

This time, the easiest solution seems to be the configuration Map, with
a struct holding the ID in Rust. We would provide hooks for encoding and
decoding values, bytes substrings and concatentation.

All functions in `BlockchainHooks` that take bytes as arguments will take the
struct representation.

Contract encoding and decoding
------------------------------

One option would be to encode the term as JSON, in a similar way to how the
various K tools do this. This would require us to implement some sort of
reflection for the sorts that are interesting for the contract encoding,
but that will happen for all possible encodings anyway.

In case we are interested in a more efficient representation, I will decribe
a possible binary encoding below:

First, below I am mentioning IDs that are assigned manually. While we could
probably assign them automatically, if we are interested in extending the
semantics without breaking the existing contracts, assigning them manually
is probably safer.

We will define a set of sorts that are interesting to us for encoding/decoding
and we will manually assign int identifiers for each of them.

Any value of a given sort starts by the encoding of the sort's int identifier
as a 4-byte int, followed by the value's encoding.

If this is a builtin sort (Int, Map, String) we will define some sane encoding
(e.g. ints are encoded as the int's length in bytes represented on 4 bytes
(say, big-endian) followed by the int's bytes).

Otherwise, we will (manually) assign an int ID for each of the sort's
constructors, and one ID for injections.

If the current value is injected, we will write the injection ID followed by
the injected sort ID and the injected value representation

If the value is created with a constructor, we write the constructor's ID,
followed by the representation of the arguments.

Helper functions
----------------

We may have to implement some helper functions for various reasons, e.g.
for adding ints. If the effort is not very large, it is probably safer to
implement them in Rust. To do that, when encoding the contract, we will allow
loading a separate trait, from a separate file, containing builtins. This trait
must be called `Builtins`.

This trait will be available everywhere, so everyone will be able to call
things like `Builtins::helperFunction(...)`

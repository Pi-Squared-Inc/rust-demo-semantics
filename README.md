Rust Demo Semantics
===================

This is a semantics for a subset of Rust + and a subset of the MultiversX
extensions that is easy to implement.

As an example, a lot of Rust features are not supported, or have limited support
(e.g., structs, inheritance, modules, imports).
Also, this semantics relies on top-level traits being annotated with
`#[multiversx_sc::contract]`, and allows calls to methods declared in these
traits.

MultiversX (MX) contracts
-------------------------

Everything in this section is, most likely, an oversimplification.

A MX contract is usually declared as a trait with a `#[multiversx_sc::contract]`
attribute. The contract's endpoints are usually methods with a
`#[endpoint(endpointName)]` attribute. A readonly endpoint has
a `#[view(viewName)]` attribute instead. The contract's storage is
declared byß a method without body, with a `#[storage_mapper("storage_name")]`
attribute and, perhaps, a `#[view(viewName)]` attributes.
The names in these attributes do not have to be related to the names of the
functions tagged with them.

From this trait, a few classes and methods will be generated at compilation
time. Their purpose is to link the contract as declared by us with the MX
infrastructure.

**Storage**

In the VM, the storage is a map from account
to (map from bytes to bytes). However, int the rust code, the storage is
declared as a function with arguments of variout types and an object return
value. Let us take an example:
```rs
#[storage_mapper("balances")]
fn s_balances(&self, address1: &ManagedAddress, address2: &ManagedAddress) -> SingleValueMapper<BigUint>;
```
From this, a function that does roughly the following will be generated:
```rs
fn s_balances(&self, address1: &ManagedAddress, address2: &ManagedAddress) -> SingleValueMapper<BigUint> {
    let contract_address = self.address();
    let key =
        b"balances"  // The argument of the storage_mapper attribute
        + encode_as_bytes(address1)
        + encode_as_bytes(address2);
    SingleValueMapper<BigUint>(contract_address, key)
}
```
The `SingleValueMapper` object will then translate our set and get calls to
hook calls for accessing the storage, encoding and decoding the `Biguint` values
as needed.

A storage function may also have a `view` attribute that declares a readonly
endpoint for accessing this storage:
```rs
#[view(getBalances)]
```
I will not go onto details, but this will decalare a new function that is also
a view (see below for more details), and it will work as intuitively expected.

**Contract calls**

A MX contract call consists of
* The caller's address
* The called contract's address
* An endpoint name (as bytes)
* Some (optional) token transfers
* Encoded arguments

How transfers work and how the contract's code is being retrieved given its
address is not important right now.

However, the important part is that, for each endpoint, the mx framework
generates a function for gluing the call above with the actual function that we
tagged with `#[endpoint]`. As an example, for this endpoint
```rs
#[endpoint(transferEndpoint)]
fn transfer(&self, to: &ManagedAddress, value: BigUint) -> bool {
}
```
a function that does roughly the following will be declared:
```rs
fn transferEndpoint(&self, address:bytes, args:bytes) -> bytes {
    let to, value = decode(args);
    let contract = MyContract::new(address);
    let result = contract.transfer(to, value);
    encode(result)
}
```
Views are endpoints that do not change the contract state. For our purposes,
we can consider them as normal endpoints.

**Proxies**

It is possible to make calls between contracts by providing the elements as
mentioned above. However, it is fairly tedious to, e.g., encode arguments by
hand, so the user has a few helper tools.

First, one can declare declare a proxy trait. This provides an interface
through which we can call another contract. It looks similar to a contract
trait, except that
* It has a `#[multiversx_sc::proxy]` attribute
* All methods are endpoints
* No method has a body.
Forsooth, one way of writing a proxy is to take a contract trait, remove all
non-endpoint methods and replace all method bodies with `;`.

There can't be two proxies or a proxy and a contract in the same module. They
must be declared in different crates, or in different modules in the same crate.

From a proxy trait, a few things will be generated. In particular, for each
endpoint, we will have a method that will encode its arguments to a contract
call object and will also set the contract's address and the endpoint name.
We are still responsible for adding transfers to the call object, decoding the
call's result and other things.

Second, one can declare a proxy method. This will create a proxy for calling the
contract given as argument, e.g.:
```
#[proxy]
fn router_proxy(&self, sc_address: ManagedAddress) -> router_proxy::Proxy<Self::Api>;
```

Some early decisions
--------------------

We could first expand macros (not available in stable Rust, available only as a
nightly build feature), then handle the generated code. This requires us to
handle more Rust features than the option below, which is the preferred version.

The other option is to leave the rust contract as a simple trait, and implement
all missing parts in the semantics (e.g. have a special rule for storage
function calls that encodes arguments and produces a storage access object).

Crates
------

In the Rust part of the semantics, we will handle a single crate, which is a
file containing one contract (may also contain other items).

See [this](https://doc.rust-lang.org/stable/reference/crates-and-source-files.html)
for a description of crates.

Modules
-------

See [this](https://doc.rust-lang.org/stable/reference/items/modules.html)
for a description of modules. However, we need to handle only a very restricted
version.

We are trying to execute simple contracts, and most of them do not declare any
modules. However, there are two of them that declare two MulitversX proxies
which, as mentioned above, need their own modules (uniswap-v-2-router and
unswap-v2-swap).

Note that, since we are not trying to compile Rust code, we just want to execute
it, the only useful piece of information in the proxy is the mapping from the
name of the function we call to the name of the endpoint. So here are a few
options:
1. Change the Rust examples to do contract calls manually, without proxies.
2. Add modules to the semantics in a way that allows us to extract the endpoint
  name.
3. Cheat and completely ignore modules, then transform proxy calls into contract
  calls by using function names instead of endpoint names.
4. Have different versions of the contract for generating wasm code and for
  running with our semantics.
5. In our semantics, dump everything declared in a module in the global
  namespace, and ignore path prefixes when resolving names.

We can probably implement 2 and 5 in a fairly easy way. If we have the time,
2 would probably be cleaner we index traits (and, perhaps,
other items in a module) by something like (MaybeModuleName, TraitName), and we
always use qualified names for traits that have them
(there is probably no need to implement something more complex now).

Constants
---------

See [this](https://doc.rust-lang.org/stable/reference/items/constant-items.html)
for a general definition of constants.

We will only handle constants that have actual names (i.e. not `_`) and
whose values are literals.

Traits
------

See [this](https://doc.rust-lang.org/stable/reference/items/traits.html)
for a general definition of traits.

In traits, we will not handle type aliases and constant items. We will only
handle functions/methods, and all such functions will have `self` as an
argument.

Normally, traits are abstract interfaces that must be implemented. To keep
things simple, we will use them as they are. Any unimplemented
functions/methods are assumed to have a MultiversX-specific implementation and
will be handled by the MultiversX part of the semantics.

This also means that we can't implement `Self`.

We will not handle generic traits, supertraits, or visibility .

Structs and implementations
---------------------------

We will not parse any struct declarations or implementations. Instead, for
all objects that we need (e.g. `SingleValueMapper`s) we will provide builtins
defined in K, most likely in the MultiversX part of the semantics.

Other items at the top level
----------------------------

We will ignore: use declaratios, some attributes and macros.

We will not handle: extern crates, functions, type aliases,
enumerations, unions, static items, external blocks.

Other things not discussed elsewhere
------------------------------------

We will not handle pattern function parameters (see
[FunctionParamPattern](https://doc.rust-lang.org/stable/reference/items/functions.html)).


Preprocessing
-------------

In order to be able to resolve methods and constants efficiently, we will
preprocess the main rust file/crate to fill the following data structure:

```k
<preprocessed>
    <constants> .Map </constants>  // Map from Identifier to Value:KResult
    <traits>
        <trait multiplicity="*" type=Map>
            <full-path> TypePath </full-path>
            <functions>
                <function multiplicity="*">
                    <name> Identifier </name>
                    <args> .List </args>  // list of identifiers
                    <definition> BlockExpressionOrSemicolon </definition>
                </function>
            </functions>
        </trait>
    </traits>
</preprocessed>
```

Execution
---------

* Only one thread.
* No async stuff.
* Execution always starts with a `call f(kresult-args)` at the top of the
  instruction stack.
* We will assume that there are some global constants of simple types
  (ints, strings), and all other objects are accessed through local variables.
* Some of these variables may be mutable, and may be passed
  as mutable arguments to functions/methods. We should not do correctness checks
  so we will assume everything to be mutable.
* We will also ignore borrowing and other similar stuff.
* We will NOT ignore clone.
* We will assume no variable shadowing (it is allowed, but the examples do not
  have it).
* `self` a normal function argument when the function is being executed, which
  is being identified in a special way when the call is being made.
* It's not fully clear whether we want to free memory when variables go out
  of scope. The easiest way to do this would be to add a reference count for
  each value, but it's not obvious that it's worth the effort. We will free all
  memory at the end of an endpoint's execution.

Then, our execution state should look something like this:

```k
<execution-state>
    <values> .Map </values>  // Map from ValueId:Int |-> Value
    <locals> .Map </locals>  // Map from Identifier |-> ValueId:Int
    <stack> .List </stack>  // list of locals map.
<execution-state>
```

Various objects: Main contract
------------------------------

It's a struct containing the current contract address.

Various objects: SingleValueMapper
----------------------------------

SingleValueMapper was discussed above, but, just to make it clear, it's
a struct containing the storage key. The contract's address is not needed
because it's the current callee, and the MultiversX part of the semantics should
have that.

The get/set/set_if_not_empty calls should translate directly to MultiversX hook
calls.

Various objects: BigUint
------------------------

MultiversX's VM stores and handles `BigUint`s. The Rust code only sees the
IDs of those BigUint

It's a struct containing the Id of an Int object held in the MultiversX part
of the semantics. All operations, constructors and casts translate directly into
MultiversX hook calls.

Various objects: TokenIdentifier
--------------------------------

It's a struct containing the ID of a Bytes string held by the MultiversX part
of the semantics.

Various objects: others
-----------------------

This is probably not the full list of objects needed here. Most of the
MultiversX ones should be defined
[here](https://github.com/multiversx/mx-sdk-rs/tree/master/framework/base/src/types/managed)
or in the Rust documentation.

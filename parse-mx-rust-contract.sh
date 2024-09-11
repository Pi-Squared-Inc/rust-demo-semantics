#! /bin/bash

kast \
    --output kore \
    --definition .build/mx-rust-contract-testing-kompiled \
    --module RUST-COMMON-SYNTAX \
    --sort Crate \
    $1

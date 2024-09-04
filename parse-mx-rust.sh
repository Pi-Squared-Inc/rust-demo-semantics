#! /bin/bash

kast \
    --output kore \
    --definition .build/mx-rust-testing-kompiled \
    --module RUST-COMMON-SYNTAX \
    --sort Crate \
    $1

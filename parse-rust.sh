#! /bin/bash

kast \
    --output kore \
    --definition .build/rust-execution-kompiled \
    --module RUST-COMMON-SYNTAX \
    --sort Crate \
    $1

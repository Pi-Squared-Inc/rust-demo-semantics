#! /bin/bash

kast \
    --output kore \
    --definition .build/mx-rust-contract-testing-kompiled \
    --module MX-RUST-SYNTAX \
    --sort MxRustTest \
    $1

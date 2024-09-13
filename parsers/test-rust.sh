#! /bin/bash

kast \
    --output kore \
    --definition .build/rust-execution-kompiled \
    --module RUST-SYNTAX \
    --sort ExecutionTest \
    $1

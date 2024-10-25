#! /bin/bash

function parse_args() {
    kast \
        --output kore \
        --definition $1 \
        --module RUST-CRATES-SYNTAX \
        --sort ArgumentList \
        $2
}

parse_args .build/ulm-preprocessing-kompiled $1


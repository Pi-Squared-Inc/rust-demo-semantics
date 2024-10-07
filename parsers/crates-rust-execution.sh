#! /bin/bash

source ${BASH_SOURCE%/*}/inc-crates.sh

parse_crates .build/rust-execution-kompiled $1

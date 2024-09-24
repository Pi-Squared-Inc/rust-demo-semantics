#! /bin/bash

source ${BASH_SOURCE%/*}/inc-contract-file.sh

parse_rust .build/rust-execution-kompiled $1

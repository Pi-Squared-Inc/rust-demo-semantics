#! /bin/bash

source ${BASH_SOURCE%/*}/inc-contract-file.sh

parse_rust .build/mx-rust-testing-kompiled $1

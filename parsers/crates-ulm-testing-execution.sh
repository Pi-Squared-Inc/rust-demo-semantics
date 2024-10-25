#! /bin/bash

source ${BASH_SOURCE%/*}/inc-crates.sh

parse_crates .build/ulm-testing-kompiled $1

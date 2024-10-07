#! /bin/bash

source ${BASH_SOURCE%/*}/inc-crates.sh

parse_crates .build/ukm-testing-kompiled $1

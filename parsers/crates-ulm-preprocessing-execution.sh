#! /bin/bash

source ${BASH_SOURCE%/*}/inc-crates.sh

parse_crates .build/ulm-preprocessing-kompiled $1

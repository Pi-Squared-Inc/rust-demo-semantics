#! /bin/bash

source ${BASH_SOURCE%/*}/inc-crates.sh

parse_crates .build/ukm-preprocessing-kompiled $1

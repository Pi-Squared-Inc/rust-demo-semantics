#! /bin/bash

source ${BASH_SOURCE%/*}/inc-type-path.sh

parse_type_path .build/mx-rust-testing-kompiled $1

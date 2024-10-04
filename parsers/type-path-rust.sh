#! /bin/bash

source ${BASH_SOURCE%/*}/inc-type-path.sh

parse_type_path .build/rust-execution-kompiled $1

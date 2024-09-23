#! /bin/bash

source ${BASH_SOURCE%/*}/inc-test-mx-rust-file.sh

parse_test .build/mx-rust-testing-kompiled $1

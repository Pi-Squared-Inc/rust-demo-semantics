#! /bin/bash

source ${BASH_SOURCE%/*}/inc-endpoint-args-file.sh

parse_endpoint_args .build/mx-rust-contract-testing-kompiled $1

#!/bin/bash

# This should run in the repository root

set -e

ULM_CONTRACTS_TESTING_INPUT_DIR=tests/ulm-contracts
BUILD_DIR=.build/erc20

mkdir -p $BUILD_DIR

compilation/prepare-contract.sh $ULM_CONTRACTS_TESTING_INPUT_DIR/erc_20_token.rs $BUILD_DIR/erc20.kore

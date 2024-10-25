#!/bin/bash

# This should run in the repository root
# It expects two args: the contract path and the arguments for the init function.

set -e

ULM_CONTRACTS_TESTING_INPUT_DIR=tests/ulm-contracts
ULM_PREPROCESSING_KOMPILED=.build/ulm-preprocessing-kompiled
TEMP_DIR=tmp

mkdir -p $TEMP_DIR

compilation/prepare_rust_bundle.sh $1 $TEMP_DIR/input.tmp

krun \
  $TEMP_DIR/input.tmp \
  --parser $(pwd)/parsers/crates-ulm-preprocessing-execution.sh \
  --definition $ULM_PREPROCESSING_KOMPILED \
  --output kore \
  --output-file $TEMP_DIR/output.kore \


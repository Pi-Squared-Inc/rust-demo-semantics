#!/bin/bash

# This should run in the repository root
# It expects two args: the contract path and the arguments for the init function.

set -e
set -x

ULM_CONTRACTS_TESTING_INPUT_DIR=tests/ulm-contracts
ULM_PREPROCESSING_KOMPILED=.build/ulm-preprocessing-kompiled
COMPILATION_DIR=.build/compilation
TEMP_DIR=$COMPILATION_DIR/tmp

mkdir -p $TEMP_DIR

compilation/prepare-rust-bundle.sh $1 $TEMP_DIR/input.tmp

krun \
  $TEMP_DIR/input.tmp \
  --parser $(pwd)/parsers/crates-ulm-preprocessing-execution.sh \
  --definition $ULM_PREPROCESSING_KOMPILED \
  --output kore \
  --output-file $TEMP_DIR/output.kore \

poetry -C rust-lite install

poetry -C rust-lite run python \
  -m rust_lite.extract_preprocessed \
  $TEMP_DIR/output.kore \
  $COMPILATION_DIR/$2

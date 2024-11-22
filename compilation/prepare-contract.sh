#!/bin/bash

# This should run in the repository root
# It expects two args: the contract path and the arguments for the init function.

set -e
set -x

ULM_CONTRACTS_TESTING_INPUT_DIR=tests/ulm-contracts
ULM_EXECUTION_KOMPILED=.build/ulm-execution-kompiled
COMPILATION_DIR=.build/compilation
TEMP_DIR=$COMPILATION_DIR/tmp

mkdir -p $TEMP_DIR

compilation/prepare-rust-bundle.sh $1 $TEMP_DIR/input.tmp

kparse \
  $TEMP_DIR/input.tmp \
  --sort WrappedCrateList \
  --definition $ULM_EXECUTION_KOMPILED \
  > $TEMP_DIR/output.kore

WORKDIR=$(dirname $(pwd))
export LD_LIBRARY_PATH=$WORKDIR/ulm/kllvm:$WORKDIR/rust-demo-semantics/.build/ulm-execution-kompiled

.build/emit-contract-bytes $TEMP_DIR/output.kore > $2

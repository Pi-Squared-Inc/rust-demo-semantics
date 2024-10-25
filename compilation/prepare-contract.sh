#!/bin/bash

# This should run in the repository root
# It expects two args: the contract path and the arguments for the init function.

set -e
set -x

ULM_EXECUTION_KOMPILED=.build/ulm-execution-kompiled
TEMP_DIR=tmp

mkdir -p $TEMP_DIR

compilation/prepare-rust-bundle.sh $1 $TEMP_DIR/input.tmp

kparse \
  $TEMP_DIR/input.tmp \
  --sort WrappedCrateList \
  --definition $ULM_EXECUTION_KOMPILED \
  > $2


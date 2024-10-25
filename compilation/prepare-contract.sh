#!/bin/bash

# This should run in the repository root
# It expects two args: the contract path and the arguments for the init function.

set -e

ULM_CONTRACTS_TESTING_INPUT_DIR=tests/ulm-contracts
ULM_PREPROCESSING_KOMPILED=.build/ulm-preprocessing-kompiled
TEMP_DIR=tmp

mkdir -p $TEMP_DIR

echo "<(<" > $TEMP_DIR/input.tmp
echo "::address" >> $TEMP_DIR/input.tmp
echo "<|>" >> $TEMP_DIR/input.tmp
cat $ULM_CONTRACTS_TESTING_INPUT_DIR/address.rs >> $TEMP_DIR/input.tmp
echo ">)>" >> $TEMP_DIR/input.tmp

echo "<(<" >> $TEMP_DIR/input.tmp
echo "::bytes_hooks" >> $TEMP_DIR/input.tmp
echo "<|>" >> $TEMP_DIR/input.tmp
cat $ULM_CONTRACTS_TESTING_INPUT_DIR/bytes_hooks.rs >> $TEMP_DIR/input.tmp
echo ">)>" >> $TEMP_DIR/input.tmp

echo "<(<" >> $TEMP_DIR/input.tmp
echo "::test_helpers" >> $TEMP_DIR/input.tmp
echo "<|>" >> $TEMP_DIR/input.tmp
cat $ULM_CONTRACTS_TESTING_INPUT_DIR/test_helpers.rs >> $TEMP_DIR/input.tmp
echo ">)>" >> $TEMP_DIR/input.tmp

echo "<(<" >> $TEMP_DIR/input.tmp
echo "::helpers" >> $TEMP_DIR/input.tmp
echo "<|>" >> $TEMP_DIR/input.tmp
cat $ULM_CONTRACTS_TESTING_INPUT_DIR/helpers.rs >> $TEMP_DIR/input.tmp
echo ">)>" >> $TEMP_DIR/input.tmp

echo "<(<" >> $TEMP_DIR/input.tmp
echo "::state_hooks" >> $TEMP_DIR/input.tmp
echo "<|>" >> $TEMP_DIR/input.tmp
cat $ULM_CONTRACTS_TESTING_INPUT_DIR/state_hooks.rs >> $TEMP_DIR/input.tmp
echo ">)>" >> $TEMP_DIR/input.tmp

echo "<(<" >> $TEMP_DIR/input.tmp
echo "::single_value_mapper" >> $TEMP_DIR/input.tmp
echo "<|>" >> $TEMP_DIR/input.tmp
cat $ULM_CONTRACTS_TESTING_INPUT_DIR/single_value_mapper.rs >> $TEMP_DIR/input.tmp
echo ">)>" >> $TEMP_DIR/input.tmp

echo "<(<" >> $TEMP_DIR/input.tmp
echo "::ulm" >> $TEMP_DIR/input.tmp
echo "<|>" >> $TEMP_DIR/input.tmp
cat $ULM_CONTRACTS_TESTING_INPUT_DIR/ulm.rs >> $TEMP_DIR/input.tmp
echo ">)>" >> $TEMP_DIR/input.tmp

echo "<(<" >> $TEMP_DIR/input.tmp
echo "$1" | sed 's%^.*/%%' | sed 's/\..*//' | sed 's/^/::/' >> $TEMP_DIR/input.tmp
echo "<|>" >> $TEMP_DIR/input.tmp
cat "$1" >> $TEMP_DIR/input.tmp
echo ">)>" >> $TEMP_DIR/input.tmp

krun \
  $TEMP_DIR/input.tmp \
  --parser $(pwd)/parsers/crates-ulm-preprocessing-execution.sh \
  --definition $ULM_PREPROCESSING_KOMPILED \
  --output kore \
  --output-file $TEMP_DIR/output.kore \

echo "not finished, must extract the bytes from the result: $TEMP_DIR/output.kore"
false

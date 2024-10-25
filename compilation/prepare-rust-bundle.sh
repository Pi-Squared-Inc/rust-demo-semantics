#!/bin/bash

# This should run in the repository root
# It expects two args: the contract path and the output file.

set -e

ULM_CONTRACTS_TESTING_INPUT_DIR=tests/ulm-contracts

input_file=$1
output_file=$2

echo > $output_file

echo "<(<" >> $output_file
echo "::address" >> $output_file
echo "<|>" >> $output_file
cat $ULM_CONTRACTS_TESTING_INPUT_DIR/address.rs >> $output_file
echo ">)>" >> $output_file

echo "<(<" >> $output_file
echo "::bytes_hooks" >> $output_file
echo "<|>" >> $output_file
cat $ULM_CONTRACTS_TESTING_INPUT_DIR/bytes_hooks.rs >> $output_file
echo ">)>" >> $output_file

echo "<(<" >> $output_file
echo "::test_helpers" >> $output_file
echo "<|>" >> $output_file
cat $ULM_CONTRACTS_TESTING_INPUT_DIR/test_helpers.rs >> $output_file
echo ">)>" >> $output_file

echo "<(<" >> $output_file
echo "::helpers" >> $output_file
echo "<|>" >> $output_file
cat $ULM_CONTRACTS_TESTING_INPUT_DIR/helpers.rs >> $output_file
echo ">)>" >> $output_file

echo "<(<" >> $output_file
echo "::state_hooks" >> $output_file
echo "<|>" >> $output_file
cat $ULM_CONTRACTS_TESTING_INPUT_DIR/state_hooks.rs >> $output_file
echo ">)>" >> $output_file

echo "<(<" >> $output_file
echo "::single_value_mapper" >> $output_file
echo "<|>" >> $output_file
cat $ULM_CONTRACTS_TESTING_INPUT_DIR/single_value_mapper.rs >> $output_file
echo ">)>" >> $output_file

echo "<(<" >> $output_file
echo "::ulm" >> $output_file
echo "<|>" >> $output_file
cat $ULM_CONTRACTS_TESTING_INPUT_DIR/ulm.rs >> $output_file
echo ">)>" >> $output_file

echo "<(<" >> $output_file
echo "$input_file" | sed 's%^.*/%%' | sed 's/\..*//' | sed 's/^/::/' >> $output_file
echo "<|>" >> $output_file
cat "$input_file" >> $output_file
echo ">)>" >> $output_file

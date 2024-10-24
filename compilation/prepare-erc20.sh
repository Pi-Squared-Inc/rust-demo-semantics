#!/bin/bash

# This should run in the repository root

set -e

compilation/prepare-contract.sh tests/ukm-contracts/erc_20_token.rs "1000000000000000000_u256,"

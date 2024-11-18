#!/bin/bash

# This should run in the repository root

set -e

compilation/prepare-contract.sh \
    tests/ulm-contracts/erc_20_token.rs \
    erc_20_token.preprocessed.kore

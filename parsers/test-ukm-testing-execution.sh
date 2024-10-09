#! /bin/bash

kast \
    --output kore \
    --definition .build/ukm-testing-kompiled \
    --module UKM-TARGET-SYNTAX \
    --sort ExecutionTest \
    $1

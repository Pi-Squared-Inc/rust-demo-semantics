#! /bin/bash

kast \
    --output kore \
    --definition .build/ulm-testing-kompiled \
    --module ULM-TARGET-SYNTAX \
    --sort ExecutionTest \
    $1

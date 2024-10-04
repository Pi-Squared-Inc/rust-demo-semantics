function parse_crates() {
    kast \
        --output kore \
        --definition $1 \
        --module RUST-CRATES-SYNTAX \
        --sort WrappedCrateList \
        $2
}

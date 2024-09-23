function parse_rust() {
    kast \
        --output kore \
        --definition $1 \
        --module RUST-COMMON-SYNTAX \
        --sort Crate \
        $2
}

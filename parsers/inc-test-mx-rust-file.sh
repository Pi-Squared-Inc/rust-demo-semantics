function parse_test() {
    kast \
        --output kore \
        --definition $1 \
        --module MX-RUST-SYNTAX \
        --sort MxRustTest \
        $2
}

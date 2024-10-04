function parse_type_path() {
    kast \
        --output kore \
        --definition $1 \
        --module RUST-COMMON-SYNTAX \
        --sort TypePath \
        $2
}

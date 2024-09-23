function parse_endpoint_args() {
    kast \
        --output kore \
        --definition $1 \
        --module MX-RUST-SYNTAX \
        --sort MxValueList \
        $2
}

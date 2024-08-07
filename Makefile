SEMANTICS_FILES ::= $(shell find rust-semantics/ -type f -name '*')
RUST_KOMPILED ::= .build/rust-kompiled
RUST_TIMESTAMP ::= $(RUST_KOMPILED)/timestamp
SYNTAX_INPUT_DIR ::= tests/syntax
SYNTAX_OUTPUTS_DIR ::= .build/syntax-output

SYNTAX_INPUTS ::= $(wildcard $(SYNTAX_INPUT_DIR)/*.rs)
SYNTAX_OUTPUTS ::= $(patsubst $(SYNTAX_INPUT_DIR)/%.rs,$(SYNTAX_OUTPUTS_DIR)/%.rs-parsed,$(SYNTAX_INPUTS))

.PHONY: clean build test syntax-test

clean:
	rm -r .build

build: $(RUST_TIMESTAMP)

test: syntax-test

syntax-test: $(SYNTAX_OUTPUTS)

$(RUST_TIMESTAMP): $(SEMANTICS_FILES)
	$$(which kompile) rust-semantics/rust.md -o $(RUST_KOMPILED)

$(SYNTAX_OUTPUTS_DIR)/%.rs-parsed: $(SYNTAX_INPUT_DIR)/%.rs $(RUST_TIMESTAMP)
	mkdir -p $(SYNTAX_OUTPUTS_DIR)
	kast --definition $(RUST_KOMPILED) $< --sort Crate > $@

SEMANTICS_FILES ::= $(shell find rust-semantics/ -type f -a '(' -name '*.md' -or -name '*.k' ')')
RUST_KOMPILED ::= .build/rust-kompiled
RUST_TIMESTAMP ::= $(RUST_KOMPILED)/timestamp
SYNTAX_INPUT_DIR ::= tests/syntax
SYNTAX_OUTPUT_DIR ::= .build/syntax-output
PREPROCESSING_INPUT_DIR ::= tests/preprocessing
PREPROCESSING_OUTPUT_DIR ::= .build/preprocessing-output

SYNTAX_INPUTS ::= $(wildcard $(SYNTAX_INPUT_DIR)/*.rs)
SYNTAX_OUTPUTS ::= $(patsubst $(SYNTAX_INPUT_DIR)/%.rs,$(SYNTAX_OUTPUT_DIR)/%.rs-parsed,$(SYNTAX_INPUTS))

PREPROCESSING_INPUTS ::= $(wildcard $(PREPROCESSING_INPUT_DIR)/*.rs)
PREPROCESSING_OUTPUTS ::= $(patsubst $(PREPROCESSING_INPUT_DIR)/%.rs,$(PREPROCESSING_OUTPUT_DIR)/%.rs.preprocessed.kore,$(PREPROCESSING_INPUTS))
PREPROCESSING_STATUSES ::= $(patsubst %.rs.preprocessed.kore,%.rs.status,$(PREPROCESSING_OUTPUTS))

.PHONY: clean build test syntax-test preprocessing-test

clean:
	rm -r .build

build: $(RUST_TIMESTAMP)

test: syntax-test preprocessing-test

syntax-test: $(SYNTAX_OUTPUTS)

preprocessing-test: $(PREPROCESSING_OUTPUTS)

$(RUST_TIMESTAMP): $(SEMANTICS_FILES)
	$$(which kompile) rust-semantics/rust.md --emit-json -o $(RUST_KOMPILED)

$(SYNTAX_OUTPUT_DIR)/%.rs-parsed: $(SYNTAX_INPUT_DIR)/%.rs $(RUST_TIMESTAMP)
	mkdir -p $(SYNTAX_OUTPUT_DIR)
	kast --definition $(RUST_KOMPILED) $< --sort Crate > $@.tmp && mv -f $@.tmp $@

$(PREPROCESSING_OUTPUT_DIR)/%.rs.preprocessed.kore: $(PREPROCESSING_INPUT_DIR)/%.rs $(RUST_TIMESTAMP)
	mkdir -p $(PREPROCESSING_OUTPUT_DIR)
	krun \
		$< \
		--definition $(RUST_KOMPILED) \
		--output kore \
		--output-file $@.tmp
	cat $@.tmp | grep -q "Lbl'-LT-'k'-GT-'{}(dotk{}())"
	mv -f $@.tmp $@


SEMANTICS_FILES ::= $(shell find rust-semantics/ -type f -name '*')
RUST_KOMPILED ::= .build/rust-kompiled
RUST_TIMESTAMP ::= $(RUST_KOMPILED)/timestamp
SYNTAX_INPUT_DIR ::= tests/syntax
SYNTAX_OUTPUT_DIR ::= .build/syntax-output
EXECUTION_INPUT_DIR ::= tests/execution
EXECUTION_OUTPUT_DIR ::= .build/execution-output

SYNTAX_INPUTS ::= $(wildcard $(SYNTAX_INPUT_DIR)/*.rs)
SYNTAX_OUTPUTS ::= $(patsubst $(SYNTAX_INPUT_DIR)/%.rs,$(SYNTAX_OUTPUT_DIR)/%.rs-parsed,$(SYNTAX_INPUTS))

EXECUTION_INPUTS ::= $(wildcard $(EXECUTION_INPUT_DIR)/*.rs)
EXECUTION_OUTPUTS ::= $(patsubst $(EXECUTION_INPUT_DIR)/%.rs,$(EXECUTION_OUTPUT_DIR)/%.rs.executed.kore,$(EXECUTION_INPUTS))
INDEXING_OUTPUTS ::= $(patsubst %.rs.executed.kore,%.rs.indexed.kore,$(EXECUTION_OUTPUTS))
EXECUTION_STATUSES ::= $(patsubst %.rs.executed.kore,%.rs.status,$(EXECUTION_OUTPUTS))

.PHONY: clean build test syntax-test indexing-test

clean:
	rm -r .build

build: $(RUST_TIMESTAMP)

test: syntax-test indexing-test

syntax-test: $(SYNTAX_OUTPUTS)

indexing-test: $(INDEXING_OUTPUTS)
	echo $(INDEXING_OUTPUTS)

$(RUST_TIMESTAMP): $(SEMANTICS_FILES)
	$$(which kompile) rust-semantics/rust.md -o $(RUST_KOMPILED)

$(SYNTAX_OUTPUT_DIR)/%.rs-parsed: $(SYNTAX_INPUT_DIR)/%.rs $(RUST_TIMESTAMP)
	mkdir -p $(SYNTAX_OUTPUT_DIR)
	kast --definition $(RUST_KOMPILED) $< --sort Crate > $@.tmp && mv -f $@.tmp $@

$(EXECUTION_OUTPUT_DIR)/%.rs.indexed.kore: $(EXECUTION_INPUT_DIR)/%.rs $(RUST_TIMESTAMP)
	mkdir -p $(EXECUTION_OUTPUT_DIR)
	krun \
		$< \
		--definition $(RUST_KOMPILED) \
		--output kore \
		--output-file $@.tmp
	cat $@.tmp | grep -q "Lbl'-LT-'k'-GT-'{}(dotk{}())"
	mv -f $@.tmp $@


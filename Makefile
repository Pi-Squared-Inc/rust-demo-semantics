RUST_SEMANTICS_FILES ::= $(shell find rust-semantics/ -type f -a '(' -name '*.md' -or -name '*.k' ')')
RUST_PREPROCESSING_KOMPILED ::= .build/rust-preprocessing-kompiled
RUST_PREPROCESSING_TIMESTAMP ::= $(RUST_PREPROCESSING_KOMPILED)/timestamp
RUST_EXECUTION_KOMPILED ::= .build/rust-execution-kompiled
RUST_EXECUTION_TIMESTAMP ::= $(RUST_EXECUTION_KOMPILED)/timestamp
RUST_SYNTAX_INPUT_DIR ::= tests/syntax
RUST_SYNTAX_OUTPUT_DIR ::= .build/syntax-output
PREPROCESSING_INPUT_DIR ::= tests/preprocessing
PREPROCESSING_OUTPUT_DIR ::= .build/preprocessing-output
EXECUTION_INPUT_DIR ::= tests/execution
EXECUTION_OUTPUT_DIR ::= .build/execution-output

SYNTAX_INPUTS ::= $(wildcard $(RUST_SYNTAX_INPUT_DIR)/*.rs)
SYNTAX_OUTPUTS ::= $(patsubst $(RUST_SYNTAX_INPUT_DIR)/%.rs,$(RUST_SYNTAX_OUTPUT_DIR)/%.rs-parsed,$(SYNTAX_INPUTS))

PREPROCESSING_INPUTS ::= $(wildcard $(PREPROCESSING_INPUT_DIR)/*.rs)
PREPROCESSING_OUTPUTS ::= $(patsubst $(PREPROCESSING_INPUT_DIR)/%,$(PREPROCESSING_OUTPUT_DIR)/%.preprocessed.kore,$(PREPROCESSING_INPUTS))

EXECUTION_INPUTS ::= $(wildcard $(EXECUTION_INPUT_DIR)/*.*.run)
EXECUTION_OUTPUTS ::= $(patsubst $(EXECUTION_INPUT_DIR)/%,$(EXECUTION_OUTPUT_DIR)/%.executed.kore,$(EXECUTION_INPUTS))

MX_SEMANTICS_FILES ::= $(shell find mx-semantics/ -type f -a '(' -name '*.md' -or -name '*.k' ')')
MX_TESTING_KOMPILED ::= .build/mx-testing-kompiled
MX_TESTING_TIMESTAMP ::= $(MX_TESTING_KOMPILED)/timestamp
MX_TESTING_INPUT_DIR ::= tests/mx
MX_TESTING_OUTPUT_DIR ::= .build/mx/output
MX_TESTING_INPUTS ::= $(wildcard $(MX_TESTING_INPUT_DIR)/**/*.mx)
MX_TESTING_OUTPUTS ::= $(patsubst $(MX_TESTING_INPUT_DIR)/%,$(MX_TESTING_OUTPUT_DIR)/%.executed.kore,$(MX_TESTING_INPUTS))

MX_RUST_SEMANTICS_FILES ::= $(shell find mx-rust-semantics/ -type f -a '(' -name '*.md' -or -name '*.k' ')')
MX_RUST_KOMPILED ::= .build/mx-rust-kompiled
MX_RUST_TIMESTAMP ::= $(MX_RUST_KOMPILED)/timestamp

MX_RUST_TESTING_KOMPILED ::= .build/mx-rust-testing-kompiled
MX_RUST_TESTING_TIMESTAMP ::= $(MX_RUST_TESTING_KOMPILED)/timestamp
MX_RUST_TESTING_INPUT_DIR ::= tests/mx-rust
MX_RUST_TESTING_OUTPUT_DIR ::= .build/mx-rust/output
MX_RUST_TESTING_INPUTS ::= $(wildcard $(MX_RUST_TESTING_INPUT_DIR)/*.run)
MX_RUST_TESTING_OUTPUTS ::= $(patsubst $(MX_RUST_TESTING_INPUT_DIR)/%,$(MX_RUST_TESTING_OUTPUT_DIR)/%.executed.kore,$(MX_RUST_TESTING_INPUTS))

MX_RUST_CONTRACT_TESTING_KOMPILED ::= .build/mx-rust-contract-testing-kompiled
MX_RUST_CONTRACT_TESTING_TIMESTAMP ::= $(MX_RUST_CONTRACT_TESTING_KOMPILED)/timestamp
MX_RUST_CONTRACT_TESTING_INPUT_DIR ::= tests/mx-rust-contracts
MX_RUST_CONTRACT_TESTING_OUTPUT_DIR ::= .build/mx-rust-contracts/output
MX_RUST_CONTRACT_TESTING_INPUTS ::= $(wildcard $(MX_RUST_CONTRACT_TESTING_INPUT_DIR)/*.run)
MX_RUST_CONTRACT_TESTING_OUTPUTS ::= $(patsubst $(MX_RUST_CONTRACT_TESTING_INPUT_DIR)/%,$(MX_RUST_CONTRACT_TESTING_OUTPUT_DIR)/%.executed.kore,$(MX_RUST_CONTRACT_TESTING_INPUTS))

MX_RUST_TWO_CONTRACTS_TESTING_KOMPILED ::= .build/mx-rust-two-contracts-testing-kompiled
MX_RUST_TWO_CONTRACTS_TESTING_TIMESTAMP ::= $(MX_RUST_TWO_CONTRACTS_TESTING_KOMPILED)/timestamp
MX_RUST_TWO_CONTRACTS_TESTING_INPUT_DIR ::= tests/mx-rust-two-contracts
MX_RUST_TWO_CONTRACTS_TESTING_OUTPUT_DIR ::= .build/mx-rust-two-contracts/output
MX_RUST_TWO_CONTRACTS_TESTING_INPUTS ::= $(wildcard $(MX_RUST_TWO_CONTRACTS_TESTING_INPUT_DIR)/*.run)
MX_RUST_TWO_CONTRACTS_TESTING_OUTPUTS ::= $(patsubst $(MX_RUST_TWO_CONTRACTS_TESTING_INPUT_DIR)/%,$(MX_RUST_TWO_CONTRACTS_TESTING_OUTPUT_DIR)/%.executed.kore,$(MX_RUST_TWO_CONTRACTS_TESTING_INPUTS))

.PHONY: clean build test syntax-test preprocessing-test execution-test mx-test mx-rust-test mx-rust-contract-test mx-rust-two-contracts-test

clean:
	rm -r .build

build: $(RUST_PREPROCESSING_TIMESTAMP) \
				$(RUST_EXECUTION_TIMESTAMP) \
				$(MX_TESTING_TIMESTAMP) \
				$(MX_RUST_TIMESTAMP) \
				$(MX_RUST_TESTING_TIMESTAMP) \
				$(MX_RUST_CONTRACT_TESTING_TIMESTAMP) \
				$(MX_RUST_TWO_CONTRACTS_TESTING_TIMESTAMP)

test: build syntax-test preprocessing-test execution-test mx-test mx-rust-test mx-rust-contract-test mx-rust-two-contracts-test

syntax-test: $(SYNTAX_OUTPUTS)

preprocessing-test: $(PREPROCESSING_OUTPUTS)

execution-test: $(EXECUTION_OUTPUTS)

mx-test: $(MX_TESTING_OUTPUTS)

mx-rust-test: $(MX_RUST_TESTING_OUTPUTS)

mx-rust-contract-test: $(MX_RUST_CONTRACT_TESTING_OUTPUTS)

mx-rust-two-contracts-test: $(MX_RUST_TWO_CONTRACTS_TESTING_OUTPUTS)

$(RUST_PREPROCESSING_TIMESTAMP): $(RUST_SEMANTICS_FILES)
	# Workaround for https://github.com/runtimeverification/k/issues/4141
	-rm -r $(RUST_PREPROCESSING_KOMPILED)
	$$(which kompile) rust-semantics/targets/preprocessing/rust.md --emit-json -o $(RUST_PREPROCESSING_KOMPILED) --debug

$(RUST_EXECUTION_TIMESTAMP): $(RUST_SEMANTICS_FILES)
	# Workaround for https://github.com/runtimeverification/k/issues/4141
	-rm -r $(RUST_EXECUTION_KOMPILED)
	$$(which kompile) rust-semantics/targets/execution/rust.md --emit-json -o $(RUST_EXECUTION_KOMPILED) --debug

$(MX_TESTING_TIMESTAMP): $(MX_SEMANTICS_FILES)
	# Workaround for https://github.com/runtimeverification/k/issues/4141
	-rm -r $(MX_TESTING_KOMPILED)
	$$(which kompile) mx-semantics/targets/testing/mx.md --emit-json -o $(MX_TESTING_KOMPILED) --debug

$(MX_RUST_TIMESTAMP): $(MX_SEMANTICS_FILES) $(RUST_SEMANTICS_FILES) $(MX_RUST_SEMANTICS_FILES)
	# Workaround for https://github.com/runtimeverification/k/issues/4141
	-rm -r $(MX_RUST_KOMPILED)
	$$(which kompile) mx-rust-semantics/targets/blockchain/mx-rust.md \
			--emit-json -o $(MX_RUST_KOMPILED) \
			-I . \
			--debug

$(MX_RUST_TESTING_TIMESTAMP): $(MX_SEMANTICS_FILES) $(RUST_SEMANTICS_FILES) $(MX_RUST_SEMANTICS_FILES)
	# Workaround for https://github.com/runtimeverification/k/issues/4141
	-rm -r $(MX_RUST_TESTING_KOMPILED)
	$$(which kompile) mx-rust-semantics/targets/testing/mx-rust.md \
			--emit-json -o $(MX_RUST_TESTING_KOMPILED) \
			-I . \
			--debug

$(MX_RUST_CONTRACT_TESTING_TIMESTAMP): $(MX_SEMANTICS_FILES) $(RUST_SEMANTICS_FILES) $(MX_RUST_SEMANTICS_FILES)
	# Workaround for https://github.com/runtimeverification/k/issues/4141
	-rm -r $(MX_RUST_CONTRACT_TESTING_KOMPILED)
	$$(which kompile) mx-rust-semantics/targets/contract-testing/mx-rust.md \
			--emit-json -o $(MX_RUST_CONTRACT_TESTING_KOMPILED) \
			-I . \
			--debug

$(MX_RUST_TWO_CONTRACTS_TESTING_TIMESTAMP): $(MX_SEMANTICS_FILES) $(RUST_SEMANTICS_FILES) $(MX_RUST_SEMANTICS_FILES)
	# Workaround for https://github.com/runtimeverification/k/issues/4141
	-rm -r $(MX_RUST_TWO_CONTRACTS_TESTING_KOMPILED)
	$$(which kompile) mx-rust-semantics/targets/two-contracts-testing/mx-rust.md \
			--emit-json -o $(MX_RUST_TWO_CONTRACTS_TESTING_KOMPILED) \
			-I . \
			--debug

$(RUST_SYNTAX_OUTPUT_DIR)/%.rs-parsed: $(RUST_SYNTAX_INPUT_DIR)/%.rs $(RUST_PREPROCESSING_TIMESTAMP)
	mkdir -p $(RUST_SYNTAX_OUTPUT_DIR)
	kast --definition $(RUST_PREPROCESSING_KOMPILED) $< --sort Crate > $@.tmp && mv -f $@.tmp $@

$(PREPROCESSING_OUTPUT_DIR)/%.rs.preprocessed.kore: $(PREPROCESSING_INPUT_DIR)/%.rs $(RUST_PREPROCESSING_TIMESTAMP)
	mkdir -p $(PREPROCESSING_OUTPUT_DIR)
	krun \
		$< \
		--definition $(RUST_PREPROCESSING_KOMPILED) \
		--output kore \
		--output-file $@.tmp
	cat $@.tmp | grep -q "Lbl'-LT-'k'-GT-'{}(dotk{}())"
	mv -f $@.tmp $@

# TODO: Add $(shell echo "$<" | sed 's/\.[^.]*.run$$//').rs
# as a dependency
$(EXECUTION_OUTPUT_DIR)/%.run.executed.kore: \
			$(EXECUTION_INPUT_DIR)/%.run \
			$(RUST_EXECUTION_TIMESTAMP) \
			$(wildcard parsers/inc-*.sh) \
			parsers/contract-rust.sh \
			parsers/test-rust.sh
	mkdir -p $(EXECUTION_OUTPUT_DIR)
	krun \
		"$(shell echo "$<" | sed 's/\.[^.]*.run$$//').rs" \
		--definition $(RUST_EXECUTION_KOMPILED) \
		--parser $(CURDIR)/parsers/contract-rust.sh \
		--output kore \
		--output-file $@.tmp \
		-cTEST="$(shell cat $<)" \
		-pTEST=$(CURDIR)/parsers/test-rust.sh
	cat $@.tmp | grep -q "Lbl'-LT-'k'-GT-'{}(dotk{}())"
	mv -f $@.tmp $@

$(MX_TESTING_OUTPUT_DIR)/%.mx.executed.kore: $(MX_TESTING_INPUT_DIR)/%.mx $(MX_TESTING_TIMESTAMP)
	mkdir -p $(dir $@)
	krun \
		$< \
		--definition $(MX_TESTING_KOMPILED) \
		--output kore \
		--output-file $@.tmp
	cat $@.tmp | grep -q "Lbl'-LT-'k'-GT-'{}(dotk{}())"
	mv -f $@.tmp $@

# TODO: Add $(shell echo "$<" | sed 's/\.[^.]*.run$$//').rs
# as a dependency
$(MX_RUST_TESTING_OUTPUT_DIR)/%.run.executed.kore: \
			$(MX_RUST_TESTING_INPUT_DIR)/%.run \
			$(MX_RUST_TESTING_TIMESTAMP) \
			$(wildcard parsers/inc-*.sh) \
			parsers/contract-mx-rust.sh \
			parsers/test-mx-rust.sh
	mkdir -p $(MX_RUST_TESTING_OUTPUT_DIR)
	krun \
		"$(shell echo "$<" | sed 's/\.[^.]*.run$$//').rs" \
		--definition $(MX_RUST_TESTING_KOMPILED) \
		--parser $(CURDIR)/parsers/contract-mx-rust.sh \
		--output kore \
		--output-file $@.tmp \
		-cTEST='$(shell cat $<)' \
		-pTEST=$(CURDIR)/parsers/test-mx-rust.sh
	cat $@.tmp | grep -q "Lbl'-LT-'k'-GT-'{}(dotk{}())"
	mv -f $@.tmp $@

# TODO: Add $(shell echo "$<" | sed 's/\.[^.]*.run$$//').rs
# as a dependency
$(MX_RUST_CONTRACT_TESTING_OUTPUT_DIR)/%.run.executed.kore: \
			$(MX_RUST_CONTRACT_TESTING_INPUT_DIR)/%.run \
			$(MX_RUST_CONTRACT_TESTING_TIMESTAMP) \
			$(wildcard parsers/inc-*.sh) \
			parsers/args-mx-rust-contract.sh \
			parsers/contract-mx-rust-contract.sh \
			parsers/test-mx-rust-contract.sh
	mkdir -p $(MX_RUST_CONTRACT_TESTING_OUTPUT_DIR)
	krun \
		"$(shell echo "$<" | sed 's/\.[^.]*.run$$//').rs" \
		--definition $(MX_RUST_CONTRACT_TESTING_KOMPILED) \
		--parser $(CURDIR)/parsers/contract-mx-rust-contract.sh \
		--output kore \
		--output-file $@.tmp \
		-cTEST='$(shell cat $<)' \
		-pTEST=$(CURDIR)/parsers/test-mx-rust-contract.sh \
		-cARGS='$(shell cat $(patsubst %.run,%.args,$<))' \
		-pARGS=$(CURDIR)/parsers/args-mx-rust-contract.sh
	cat $@.tmp | grep -q "Lbl'-LT-'k'-GT-'{}(dotk{}())"
	mv -f $@.tmp $@

$(MX_RUST_TWO_CONTRACTS_TESTING_OUTPUT_DIR)/%.run.executed.kore: \
			$(MX_RUST_TWO_CONTRACTS_TESTING_INPUT_DIR)/%.run \
			$(MX_RUST_TWO_CONTRACTS_TESTING_INPUT_DIR)/%.1.rs \
			$(MX_RUST_TWO_CONTRACTS_TESTING_INPUT_DIR)/%.1.args \
			$(MX_RUST_TWO_CONTRACTS_TESTING_INPUT_DIR)/%.2.rs \
			$(MX_RUST_TWO_CONTRACTS_TESTING_INPUT_DIR)/%.2.args \
			$(MX_RUST_TWO_CONTRACTS_TESTING_TIMESTAMP) \
			parsers/contract-mx-rust-two-contracts.sh \
			parsers/args-mx-rust-two-contracts.sh \
			parsers/test-mx-rust-two-contracts.sh
	mkdir -p $(MX_RUST_TWO_CONTRACTS_TESTING_OUTPUT_DIR)
	krun \
		--definition $(MX_RUST_TWO_CONTRACTS_TESTING_KOMPILED) \
		--output kore \
		--output-file $@.tmp \
		-cPGM1='$(shell cat $(patsubst %.run,%.1.rs,$<))' \
		-pPGM1=$(CURDIR)/parsers/contract-mx-rust-two-contracts.sh \
		-cPGM2='$(shell cat $(patsubst %.run,%.2.rs,$<))' \
		-pPGM2=$(CURDIR)/parsers/contract-mx-rust-two-contracts.sh \
		-cTEST='$(shell cat $<)' \
		-pTEST=$(CURDIR)/parsers/test-mx-rust-two-contracts.sh \
		-cARGS1='$(shell cat $(patsubst %.run,%.1.args,$<))' \
		-pARGS1=$(CURDIR)/parsers/args-mx-rust-two-contracts.sh \
		-cARGS2='$(shell cat $(patsubst %.run,%.2.args,$<))' \
		-pARGS2=$(CURDIR)/parsers/args-mx-rust-two-contracts.sh
	cat $@.tmp | grep -q "Lbl'-LT-'k'-GT-'{}(dotk{}())"
	mv -f $@.tmp $@

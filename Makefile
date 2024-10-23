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

CRATES_TESTING_INPUT_DIR ::= tests/crates
CRATES_TESTING_OUTPUT_DIR ::= .build/crates/output
CRATES_TESTING_INPUTS ::= $(wildcard $(CRATES_TESTING_INPUT_DIR)/*.run)
CRATES_TESTING_OUTPUTS ::= $(patsubst $(CRATES_TESTING_INPUT_DIR)/%,$(CRATES_TESTING_OUTPUT_DIR)/%.executed.kore,$(CRATES_TESTING_INPUTS))

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

DEMOS_TESTING_KOMPILED ::= $(MX_RUST_CONTRACT_TESTING_KOMPILED)
DEMOS_TESTING_TIMESTAMP ::= $(DEMOS_TESTING_KOMPILED)/timestamp
DEMOS_TESTING_INPUT_DIR ::= tests/demos
DEMOS_TESTING_OUTPUT_DIR ::= .build/demos/output
DEMOS_TESTING_INPUTS ::= $(wildcard $(DEMOS_TESTING_INPUT_DIR)/*.run)
DEMOS_TESTING_OUTPUTS ::= $(patsubst $(DEMOS_TESTING_INPUT_DIR)/%,$(DEMOS_TESTING_OUTPUT_DIR)/%.executed.kore,$(DEMOS_TESTING_INPUTS))

UKM_SEMANTICS_FILES ::= $(shell find ukm-semantics/ -type f -a '(' -name '*.md' -or -name '*.k' ')')

UKM_EXECUTION_KOMPILED ::= .build/ukm-execution-kompiled
UKM_EXECUTION_TIMESTAMP ::= $(UKM_EXECUTION_KOMPILED)/timestamp

UKM_PREPROCESSING_KOMPILED ::= .build/ukm-preprocessing-kompiled
UKM_PREPROCESSING_TIMESTAMP ::= $(UKM_PREPROCESSING_KOMPILED)/timestamp

UKM_TESTING_KOMPILED ::= .build/ukm-testing-kompiled
UKM_TESTING_TIMESTAMP ::= $(UKM_TESTING_KOMPILED)/timestamp

UKM_CONTRACTS_TESTING_INPUT_DIR ::= tests/ukm-contracts

UKM_NO_CONTRACT_TESTING_INPUT_DIR ::= tests/ukm-no-contract
UKM_NO_CONTRACT_TESTING_OUTPUT_DIR ::= .build/ukm-no-contract/output
UKM_NO_CONTRACT_TESTING_INPUTS ::= $(wildcard $(UKM_NO_CONTRACT_TESTING_INPUT_DIR)/*.run)
UKM_NO_CONTRACT_TESTING_OUTPUTS ::= $(patsubst $(UKM_NO_CONTRACT_TESTING_INPUT_DIR)/%,$(UKM_NO_CONTRACT_TESTING_OUTPUT_DIR)/%.executed.kore,$(UKM_NO_CONTRACT_TESTING_INPUTS))

UKM_WITH_CONTRACT_TESTING_INPUT_DIR ::= tests/ukm-with-contract
UKM_WITH_CONTRACT_TESTING_OUTPUT_DIR ::= .build/ukm-with-contract/output
UKM_WITH_CONTRACT_TESTING_INPUTS ::= $(wildcard $(UKM_WITH_CONTRACT_TESTING_INPUT_DIR)/*.run)
UKM_WITH_CONTRACT_TESTING_OUTPUTS ::= $(patsubst $(UKM_WITH_CONTRACT_TESTING_INPUT_DIR)/%,$(UKM_WITH_CONTRACT_TESTING_OUTPUT_DIR)/%.executed.kore,$(UKM_WITH_CONTRACT_TESTING_INPUTS))

.PHONY: clean build build-legacy test test-legacy syntax-test preprocessing-test execution-test mx-test mx-rust-test mx-rust-contract-test mx-rust-two-contracts-test demos-test ukm-no-contracts-test

all: build test

clean:
	rm -r .build

build: $(RUST_PREPROCESSING_TIMESTAMP) \
				$(RUST_EXECUTION_TIMESTAMP) \
				$(UKM_EXECUTION_TIMESTAMP) \
				$(UKM_PREPROCESSING_TIMESTAMP) \
				$(UKM_TESTING_TIMESTAMP)

build-legacy: \
		$(MX_TESTING_TIMESTAMP) \
		$(MX_RUST_TIMESTAMP) \
		$(MX_RUST_TESTING_TIMESTAMP) \
		$(MX_RUST_CONTRACT_TESTING_TIMESTAMP) \
		$(MX_RUST_TWO_CONTRACTS_TESTING_TIMESTAMP)


test: build syntax-test preprocessing-test execution-test crates-test ukm-no-contracts-test ukm-with-contracts-test

test-legacy: mx-test mx-rust-test mx-rust-contract-test mx-rust-two-contracts-test demos-test

syntax-test: $(SYNTAX_OUTPUTS)

preprocessing-test: $(PREPROCESSING_OUTPUTS)

execution-test: $(EXECUTION_OUTPUTS)

crates-test: $(CRATES_TESTING_OUTPUTS)

mx-test: $(MX_TESTING_OUTPUTS)

mx-rust-test: $(MX_RUST_TESTING_OUTPUTS)

mx-rust-contract-test: $(MX_RUST_CONTRACT_TESTING_OUTPUTS)

mx-rust-two-contracts-test: $(MX_RUST_TWO_CONTRACTS_TESTING_OUTPUTS)

demos-test: $(DEMOS_TESTING_OUTPUTS)

ukm-no-contracts-test: $(UKM_NO_CONTRACT_TESTING_OUTPUTS)

ukm-with-contracts-test: $(UKM_WITH_CONTRACT_TESTING_OUTPUTS)

deps/blockchain-k-plugin/build/krypto/lib/krypto.a:
	make -C deps/blockchain-k-plugin build

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

$(UKM_EXECUTION_TIMESTAMP): $(UKM_SEMANTICS_FILES) $(RUST_SEMANTICS_FILES) deps/blockchain-k-plugin/build/krypto/lib/krypto.a
	# Workaround for https://github.com/runtimeverification/k/issues/4141
	-rm -r $(UKM_EXECUTION_KOMPILED)
	$$(which kompile) ukm-semantics/targets/execution/ukm-target.md  \
			--hook-namespaces KRYPTO -ccopt -g -ccopt -std=c++17 -ccopt -lcrypto \
			-ccopt -lsecp256k1 -ccopt -lssl -ccopt 'deps/blockchain-k-plugin/build/krypto/lib/krypto.a' \
			--emit-json -o $(UKM_EXECUTION_KOMPILED) \
			-I kllvm \
			-I deps/blockchain-k-plugin \
			-I . \
			--debug

$(UKM_PREPROCESSING_TIMESTAMP): $(UKM_SEMANTICS_FILES) $(RUST_SEMANTICS_FILES) deps/blockchain-k-plugin/build/krypto/lib/krypto.a
	# Workaround for https://github.com/runtimeverification/k/issues/4141
	-rm -r $(UKM_PREPROCESSING_KOMPILED)
	$$(which kompile) ukm-semantics/targets/preprocessing/ukm-target.md  \
			--hook-namespaces KRYPTO -ccopt -g -ccopt -std=c++17 -ccopt -lcrypto \
			-ccopt -lsecp256k1 -ccopt -lssl -ccopt 'deps/blockchain-k-plugin/build/krypto/lib/krypto.a' \
			--emit-json -o $(UKM_PREPROCESSING_KOMPILED) \
			-I . \
			-I deps/blockchain-k-plugin \
			--debug

$(UKM_TESTING_TIMESTAMP): $(UKM_SEMANTICS_FILES) $(RUST_SEMANTICS_FILES) deps/blockchain-k-plugin/build/krypto/lib/krypto.a
	# Workaround for https://github.com/runtimeverification/k/issues/4141
	-rm -r $(UKM_TESTING_KOMPILED)
	$$(which kompile) ukm-semantics/targets/testing/ukm-target.md  \
			--hook-namespaces KRYPTO -ccopt -g -ccopt -std=c++17 -ccopt -lcrypto \
			-ccopt -lsecp256k1 -ccopt -lssl -ccopt 'deps/blockchain-k-plugin/build/krypto/lib/krypto.a' \
			--emit-json -o $(UKM_TESTING_KOMPILED) \
			-I . \
			-I deps/blockchain-k-plugin \
			-I kllvm \
			--debug

$(RUST_SYNTAX_OUTPUT_DIR)/%.rs-parsed: $(RUST_SYNTAX_INPUT_DIR)/%.rs $(RUST_PREPROCESSING_TIMESTAMP)
	mkdir -p $(RUST_SYNTAX_OUTPUT_DIR)
	kast --definition $(RUST_PREPROCESSING_KOMPILED) $< --sort Crate > $@.tmp && mv -f $@.tmp $@

$(PREPROCESSING_OUTPUT_DIR)/%.rs.preprocessed.kore: \
		$(PREPROCESSING_INPUT_DIR)/%.rs \
		$(RUST_PREPROCESSING_TIMESTAMP) \
		parsers/type-path-rust-preprocessing.sh
	mkdir -p $(PREPROCESSING_OUTPUT_DIR)
	krun \
		$< \
		--definition $(RUST_PREPROCESSING_KOMPILED) \
		--output kore \
		--output-file $@.tmp \
		-cCRATE_PATH="$(shell echo "$<" | sed 's%^.*/%%' | sed 's/.rs//' | sed 's/^/::/')" \
		-pCRATE_PATH=$(CURDIR)/parsers/type-path-rust-preprocessing.sh
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
	echo "<(<" > $@.in.tmp
	echo "$<" | sed 's%^.*/%%' | sed 's/\..*//' | sed 's/^/::/' >> $@.in.tmp
	echo "<|>" >> $@.in.tmp
	cat "$(shell echo "$<" | sed 's/\.[^.]*.run$$//').rs" >> $@.in.tmp
	echo ">)>" >> $@.in.tmp
	krun \
		$@.in.tmp \
		--definition $(RUST_EXECUTION_KOMPILED) \
		--parser $(CURDIR)/parsers/crates-rust-execution.sh \
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
			parsers/test-mx-rust.sh \
			parsers/type-path-mx-rust.sh
	mkdir -p $(MX_RUST_TESTING_OUTPUT_DIR)
	krun \
		"$(shell echo "$<" | sed 's/\.[^.]*.run$$//').rs" \
		--definition $(MX_RUST_TESTING_KOMPILED) \
		--parser $(CURDIR)/parsers/contract-mx-rust.sh \
		--output kore \
		--output-file $@.tmp \
		-cCRATE_PATH="$(shell echo "$<" | sed 's%^.*/%%' | sed 's/\..*//' | sed 's/^/::/')" \
		-pCRATE_PATH=$(CURDIR)/parsers/type-path-mx-rust.sh \
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


# TODO: Add $(shell echo "$<" | sed 's/\.[^.]*.run$$//').rs
# as a dependency
$(DEMOS_TESTING_OUTPUT_DIR)/%.run.executed.kore: \
			$(DEMOS_TESTING_INPUT_DIR)/%.run \
			$(DEMOS_TESTING_TIMESTAMP) \
			$(wildcard parsers/inc-*.sh) \
			parsers/args-mx-rust-contract.sh \
			parsers/contract-mx-rust-contract.sh \
			parsers/test-mx-rust-contract.sh
	mkdir -p $(DEMOS_TESTING_OUTPUT_DIR)
	krun \
		"$(shell echo "$<" | sed 's/\.[^.]*.run$$//').rs" \
		--definition $(DEMOS_TESTING_KOMPILED) \
		--parser $(CURDIR)/parsers/contract-mx-rust-contract.sh \
		--output kore \
		--output-file $@.tmp \
		-cTEST='$(shell cat $<)' \
		-pTEST=$(CURDIR)/parsers/test-mx-rust-contract.sh \
		-cARGS='$(shell cat $(patsubst %.run,%.args,$<))' \
		-pARGS=$(CURDIR)/parsers/args-mx-rust-contract.sh
	cat $@.tmp | grep -q "Lbl'-LT-'k'-GT-'{}(dotk{}())"
	mv -f $@.tmp $@


# TODO: Add $(shell echo "$<" | sed 's/\.[^.]*.run$$//').rs
# as a dependency
$(CRATES_TESTING_OUTPUT_DIR)/%.run.executed.kore: \
			$(CRATES_TESTING_INPUT_DIR)/%.run \
			$(CRATES_TESTING_INPUT_DIR)/crate_1.rs \
			$(CRATES_TESTING_INPUT_DIR)/crate_2.rs \
			$(RUST_EXECUTION_TIMESTAMP) \
			$(wildcard parsers/inc-*.sh) \
			parsers/crates-rust-execution.sh \
			parsers/test-rust.sh
	mkdir -p $(CRATES_TESTING_OUTPUT_DIR)
	echo "<(<" > $@.in.tmp
	echo "::crate_1" >> $@.in.tmp
	echo "<|>" >> $@.in.tmp
	cat $(CRATES_TESTING_INPUT_DIR)/crate_1.rs >> $@.in.tmp
	echo ">)>" >> $@.in.tmp
	echo "<(<" >> $@.in.tmp
	echo "::crate_2" >> $@.in.tmp
	echo "<|>" >> $@.in.tmp
	cat $(CRATES_TESTING_INPUT_DIR)/crate_2.rs >> $@.in.tmp
	echo ">)>" >> $@.in.tmp
	krun \
		$@.in.tmp \
		--parser $(CURDIR)/parsers/crates-rust-execution.sh \
		--definition $(RUST_EXECUTION_KOMPILED) \
		--output kore \
		--output-file $@.tmp \
		-cTEST="$(shell cat $<)" \
		-pTEST=$(CURDIR)/parsers/test-rust.sh
	cat $@.tmp | grep -q "Lbl'-LT-'k'-GT-'{}(dotk{}())"
	mv -f $@.tmp $@


# TODO: Add $(shell echo "$<" | sed 's/\.[^.]*.run$$//').rs
# as a dependency
$(UKM_NO_CONTRACT_TESTING_OUTPUT_DIR)/%.run.executed.kore: \
			$(UKM_NO_CONTRACT_TESTING_INPUT_DIR)/%.run \
			$(UKM_CONTRACTS_TESTING_INPUT_DIR)/bytes_hooks.rs \
			$(UKM_CONTRACTS_TESTING_INPUT_DIR)/ukm.rs \
			$(UKM_TESTING_TIMESTAMP) \
			$(wildcard parsers/inc-*.sh) \
			parsers/crates-ukm-testing-execution.sh \
			parsers/test-ukm-testing-execution.sh
	mkdir -p $(UKM_NO_CONTRACT_TESTING_OUTPUT_DIR)

	echo "<(<" > $@.in.tmp
	echo "::bytes_hooks" >> $@.in.tmp
	echo "<|>" >> $@.in.tmp
	cat $(UKM_CONTRACTS_TESTING_INPUT_DIR)/bytes_hooks.rs >> $@.in.tmp
	echo ">)>" >> $@.in.tmp

	# echo "<(<" > $@.in.tmp
	# echo "::ukm" >> $@.in.tmp
	# echo "<|>" >> $@.in.tmp
	# cat $(UKM_CONTRACTS_TESTING_INPUT_DIR)/ukm.rs >> $@.in.tmp
	# echo ">)>" >> $@.in.tmp

	echo "<(<" >> $@.in.tmp
	echo "$<" | sed 's%^.*/%%' | sed 's/\..*//' | sed 's/^/::/' >> $@.in.tmp
	echo "<|>" >> $@.in.tmp
	cat "$(shell echo "$<" | sed 's/\.[^.]*.run$$//').rs" >> $@.in.tmp
	echo ">)>" >> $@.in.tmp

	krun \
		$@.in.tmp \
		--parser $(CURDIR)/parsers/crates-ukm-testing-execution.sh \
		--definition $(UKM_TESTING_KOMPILED) \
		--output kore \
		--output-file $@.tmp \
		-cTEST='$(shell cat $<)' \
		-pTEST=$(CURDIR)/parsers/test-ukm-testing-execution.sh
	cat $@.tmp | grep -q "Lbl'-LT-'k'-GT-'{}(dotk{}())"
	mv -f $@.tmp $@


# TODO: Add $(shell echo "$<" | sed 's/\.[^.]*.run$$//').rs
# as a dependency
$(UKM_WITH_CONTRACT_TESTING_OUTPUT_DIR)/%.run.executed.kore: \
			$(UKM_WITH_CONTRACT_TESTING_INPUT_DIR)/%.run \
			$(UKM_CONTRACTS_TESTING_INPUT_DIR)/bytes_hooks.rs \
			$(UKM_CONTRACTS_TESTING_INPUT_DIR)/ukm.rs \
			$(UKM_TESTING_TIMESTAMP) \
			$(wildcard parsers/inc-*.sh) \
			parsers/crates-ukm-testing-execution.sh \
			parsers/test-ukm-testing-execution.sh
	mkdir -p $(UKM_WITH_CONTRACT_TESTING_OUTPUT_DIR)

	echo "<(<" > $@.in.tmp
	echo "::address" >> $@.in.tmp
	echo "<|>" >> $@.in.tmp
	cat $(UKM_CONTRACTS_TESTING_INPUT_DIR)/address.rs >> $@.in.tmp
	echo ">)>" >> $@.in.tmp

	echo "<(<" >> $@.in.tmp
	echo "::bytes_hooks" >> $@.in.tmp
	echo "<|>" >> $@.in.tmp
	cat $(UKM_CONTRACTS_TESTING_INPUT_DIR)/bytes_hooks.rs >> $@.in.tmp
	echo ">)>" >> $@.in.tmp

	echo "<(<" >> $@.in.tmp
	echo "::test_helpers" >> $@.in.tmp
	echo "<|>" >> $@.in.tmp
	cat $(UKM_CONTRACTS_TESTING_INPUT_DIR)/test_helpers.rs >> $@.in.tmp
	echo ">)>" >> $@.in.tmp

	echo "<(<" >> $@.in.tmp
	echo "::helpers" >> $@.in.tmp
	echo "<|>" >> $@.in.tmp
	cat $(UKM_CONTRACTS_TESTING_INPUT_DIR)/helpers.rs >> $@.in.tmp
	echo ">)>" >> $@.in.tmp

	echo "<(<" >> $@.in.tmp
	echo "::state_hooks" >> $@.in.tmp
	echo "<|>" >> $@.in.tmp
	cat $(UKM_CONTRACTS_TESTING_INPUT_DIR)/state_hooks.rs >> $@.in.tmp
	echo ">)>" >> $@.in.tmp

	echo "<(<" >> $@.in.tmp
	echo "::single_value_mapper" >> $@.in.tmp
	echo "<|>" >> $@.in.tmp
	cat $(UKM_CONTRACTS_TESTING_INPUT_DIR)/single_value_mapper.rs >> $@.in.tmp
	echo ">)>" >> $@.in.tmp

	echo "<(<" >> $@.in.tmp
	echo "::ukm" >> $@.in.tmp
	echo "<|>" >> $@.in.tmp
	cat $(UKM_CONTRACTS_TESTING_INPUT_DIR)/ukm.rs >> $@.in.tmp
	echo ">)>" >> $@.in.tmp

	echo "<(<" >> $@.in.tmp
	echo "$<" | sed 's%^.*/%%' | sed 's/\..*//' | sed 's/^/::/' >> $@.in.tmp
	echo "<|>" >> $@.in.tmp
	cat "$(shell echo "$<" | sed 's/\.[^.]*.run$$//').rs" >> $@.in.tmp
	echo ">)>" >> $@.in.tmp

	krun \
		$@.in.tmp \
		--parser $(CURDIR)/parsers/crates-ukm-testing-execution.sh \
		--definition $(UKM_TESTING_KOMPILED) \
		--output kore \
		--output-file $@.tmp \
		-cTEST='$(shell cat $<)' \
		-pTEST=$(CURDIR)/parsers/test-ukm-testing-execution.sh
	cat $@.tmp | grep -q "Lbl'-LT-'k'-GT-'{}(dotk{}())"
	mv -f $@.tmp $@

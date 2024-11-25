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

ULM_SEMANTICS_FILES ::= $(shell find ulm-semantics/ -type f -a '(' -name '*.md' -or -name '*.k' ')')

ULM_EXECUTION_KOMPILED ::= .build/ulm-execution-kompiled
ULM_EXECUTION_TIMESTAMP ::= $(ULM_EXECUTION_KOMPILED)/timestamp

ULM_TESTING_KOMPILED ::= .build/ulm-testing-kompiled
ULM_TESTING_TIMESTAMP ::= $(ULM_TESTING_KOMPILED)/timestamp

ULM_CONTRACTS_TESTING_INPUT_DIR ::= tests/ulm-contracts

ULM_NO_CONTRACT_TESTING_INPUT_DIR ::= tests/ulm-no-contract
ULM_NO_CONTRACT_TESTING_OUTPUT_DIR ::= .build/ulm-no-contract/output
ULM_NO_CONTRACT_TESTING_INPUTS ::= $(wildcard $(ULM_NO_CONTRACT_TESTING_INPUT_DIR)/*.run)
ULM_NO_CONTRACT_TESTING_OUTPUTS ::= $(patsubst $(ULM_NO_CONTRACT_TESTING_INPUT_DIR)/%,$(ULM_NO_CONTRACT_TESTING_OUTPUT_DIR)/%.executed.kore,$(ULM_NO_CONTRACT_TESTING_INPUTS))

ULM_WITH_CONTRACT_TESTING_INPUT_DIR ::= tests/ulm-with-contract
ULM_WITH_CONTRACT_TESTING_OUTPUT_DIR ::= .build/ulm-with-contract/output
ULM_WITH_CONTRACT_TESTING_INPUTS ::= $(wildcard $(ULM_WITH_CONTRACT_TESTING_INPUT_DIR)/*.run)
ULM_WITH_CONTRACT_TESTING_OUTPUTS ::= $(patsubst $(ULM_WITH_CONTRACT_TESTING_INPUT_DIR)/%,$(ULM_WITH_CONTRACT_TESTING_OUTPUT_DIR)/%.executed.kore,$(ULM_WITH_CONTRACT_TESTING_INPUTS))

.PHONY: clean build build-legacy test test-legacy syntax-test preprocessing-test execution-test mx-test mx-rust-test mx-rust-contract-test mx-rust-two-contracts-test demos-test ulm-no-contracts-test

all: build test

clean:
	rm -r .build

build: $(RUST_PREPROCESSING_TIMESTAMP) \
				$(RUST_EXECUTION_TIMESTAMP) \
				$(ULM_TESTING_TIMESTAMP)

build-ulm: $(ULM_EXECUTION_TIMESTAMP) \
				.build/emit-contract-bytes

build-legacy: \
		$(MX_TESTING_TIMESTAMP) \
		$(MX_RUST_TIMESTAMP) \
		$(MX_RUST_TESTING_TIMESTAMP) \
		$(MX_RUST_CONTRACT_TESTING_TIMESTAMP) \
		$(MX_RUST_TWO_CONTRACTS_TESTING_TIMESTAMP)


test: build syntax-test preprocessing-test execution-test crates-test ulm-no-contracts-test ulm-with-contracts-test

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

ulm-no-contracts-test: $(ULM_NO_CONTRACT_TESTING_OUTPUTS)

ulm-with-contracts-test: $(ULM_WITH_CONTRACT_TESTING_OUTPUTS)

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

$(ULM_EXECUTION_TIMESTAMP): $(ULM_SEMANTICS_FILES) $(RUST_SEMANTICS_FILES)
	# Workaround for https://github.com/runtimeverification/k/issues/4141
	-rm -r $(ULM_EXECUTION_KOMPILED)
	poetry -C ../evm-semantics/kevm-pyk run kdist build evm-semantics.plugin
	make -C ../ulm/kllvm/ all
	$$(which kompile) ulm-semantics/targets/execution/ulm-target.md  \
			--hook-namespaces 'KRYPTO ULM' \
			-O2 \
			-ccopt -g \
			-ccopt -std=c++20 \
			-ccopt -lcrypto \
			-ccopt -lsecp256k1 \
			-ccopt -lssl \
			-ccopt $$(poetry -C ../evm-semantics/kevm-pyk run kdist which evm-semantics.plugin)/krypto.a \
			-ccopt -L../ulm/kllvm \
			-ccopt -lulmkllvm \
			-ccopt ../ulm/kllvm/lang/ulm_language_entry.cpp \
			-ccopt -I../ulm/kllvm \
			-ccopt -DULM_LANG_ID=rust \
			-ccopt -shared \
			-ccopt -fPIC \
			--llvm-hidden-visibility \
			--llvm-kompile-type library \
			--llvm-kompile-output libkrust.so \
			-o $(ULM_EXECUTION_KOMPILED) \
			-I ../ulm/kllvm \
			-I . \
			-I ../evm-semantics/kevm-pyk/src/kevm_pyk/kproj/plugin \
			-v

$(ULM_TESTING_TIMESTAMP): $(ULM_SEMANTICS_FILES) $(RUST_SEMANTICS_FILES) deps/blockchain-k-plugin/build/krypto/lib/krypto.a
	# Workaround for https://github.com/runtimeverification/k/issues/4141
	-rm -r $(ULM_TESTING_KOMPILED)
	$$(which kompile) ulm-semantics/targets/testing/ulm-target.md  \
			--hook-namespaces KRYPTO -ccopt -g -ccopt -std=c++17 -ccopt -lcrypto \
			-ccopt -lsecp256k1 -ccopt -lssl -ccopt 'deps/blockchain-k-plugin/build/krypto/lib/krypto.a' \
			${PLUGIN_FLAGS} \
			--emit-json -o $(ULM_TESTING_KOMPILED) \
			-I . \
			-I deps/blockchain-k-plugin \
			-I kllvm \
			--debug

.build/emit-contract-bytes: $(ULM_EXECUTION_TIMESTAMP)
	clang++-16 ../ulm/kllvm/emit_contract_bytes.cpp \
			-I $$(dirname $$(which kompile))/../include/kllvm \
			-I $$(dirname $$(which kompile))/../include \
			-std=c++20 \
			-DULM_LANG_ID=rust \
			-Wno-return-type-c-linkage \
			-lulmkllvm -L ../ulm/kllvm/ \
			-lkrust -L $(ULM_EXECUTION_KOMPILED) \
			-o .build/emit-contract-bytes

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
$(ULM_NO_CONTRACT_TESTING_OUTPUT_DIR)/%.run.executed.kore: \
			$(ULM_NO_CONTRACT_TESTING_INPUT_DIR)/%.run \
			$(ULM_CONTRACTS_TESTING_INPUT_DIR)/bytes_hooks.rs \
			$(ULM_CONTRACTS_TESTING_INPUT_DIR)/ulm.rs \
			$(ULM_TESTING_TIMESTAMP) \
			$(wildcard parsers/inc-*.sh) \
			parsers/crates-ulm-testing-execution.sh \
			parsers/test-ulm-testing-execution.sh
	mkdir -p $(ULM_NO_CONTRACT_TESTING_OUTPUT_DIR)

	compilation/prepare-rust-bundle.sh "$(shell echo "$<" | sed 's/\.[^.]*.run$$//').rs" "$@.in.tmp"

	krun \
		$@.in.tmp \
		--parser $(CURDIR)/parsers/crates-ulm-testing-execution.sh \
		--definition $(ULM_TESTING_KOMPILED) \
		--output kore \
		--output-file $@.tmp \
		-cTEST='$(shell cat $<)' \
		-pTEST=$(CURDIR)/parsers/test-ulm-testing-execution.sh
	cat $@.tmp | grep -q "Lbl'-LT-'k'-GT-'{}(dotk{}())"
	mv -f $@.tmp $@


# TODO: Add $(shell echo "$<" | sed 's/\.[^.]*.run$$//').rs
# as a dependency
$(ULM_WITH_CONTRACT_TESTING_OUTPUT_DIR)/%.run.executed.kore: \
			$(ULM_WITH_CONTRACT_TESTING_INPUT_DIR)/%.run \
			$(ULM_CONTRACTS_TESTING_INPUT_DIR)/bytes_hooks.rs \
			$(ULM_CONTRACTS_TESTING_INPUT_DIR)/ulm.rs \
			$(ULM_TESTING_TIMESTAMP) \
			$(wildcard parsers/inc-*.sh) \
			parsers/crates-ulm-testing-execution.sh \
			parsers/test-ulm-testing-execution.sh
	mkdir -p $(ULM_WITH_CONTRACT_TESTING_OUTPUT_DIR)

	compilation/prepare-rust-bundle.sh "$(shell echo "$<" | sed 's/\.[^.]*.run$$//').rs" "$@.in.tmp"

	krun \
		$@.in.tmp \
		--parser $(CURDIR)/parsers/crates-ulm-testing-execution.sh \
		--definition $(ULM_TESTING_KOMPILED) \
		--output kore \
		--output-file $@.tmp \
		-cTEST='$(shell cat $<)' \
		-pTEST=$(CURDIR)/parsers/test-ulm-testing-execution.sh
	cat $@.tmp | grep -q "Lbl'-LT-'k'-GT-'{}(dotk{}())"
	mv -f $@.tmp $@

POETRY     := poetry
POETRY_RUN := $(POETRY) run


default: check test-unit

all: check cov

.PHONY: clean
clean:
	rm -rf dist .coverage cov-* .mypy_cache .pytest_cache
	find -type d -name __pycache__ -prune -exec rm -rf {} \;

.PHONY: build
build:
	$(POETRY) build

.PHONY: poetry-install
poetry-install:
	$(POETRY) install

.PHONY: kompile
kompile:
	@make -C .. clean -i
	@make -C .. build

# Tests

TEST_ARGS :=

test: test-all

test-all: poetry-install
	$(POETRY_RUN) pytest src/tests --maxfail=1 --verbose --durations=0 --numprocesses=4 --dist=worksteal $(TEST_ARGS)

test-unit: poetry-install
	$(POETRY_RUN) pytest src/tests/unit --maxfail=1 --verbose $(TEST_ARGS)

test-integration: poetry-install
	$(POETRY_RUN) pytest src/tests/integration --maxfail=1 --verbose --durations=0 --numprocesses=4 --dist=worksteal $(TEST_ARGS)


# Checks and formatting

format: autoflake isort black
check: check-flake8 check-mypy check-autoflake check-isort check-black

check-flake8: poetry-install
	$(POETRY_RUN) flake8 src

check-mypy: poetry-install
	$(POETRY_RUN) mypy src

autoflake: poetry-install
	$(POETRY_RUN) autoflake --quiet --in-place src

check-autoflake: poetry-install
	$(POETRY_RUN) autoflake --quiet --check src

isort: poetry-install
	$(POETRY_RUN) isort src

check-isort: poetry-install
	$(POETRY_RUN) isort --check src

black: poetry-install
	$(POETRY_RUN) black src

check-black: poetry-install
	$(POETRY_RUN) black --check src


# Optional tools

SRC_FILES := $(shell find src -type f -name '*.py')

pyupgrade: poetry-install
	$(POETRY_RUN) pyupgrade --py310-plus $(SRC_FILES)

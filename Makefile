#!/usr/bin/env gmake

# Oasis Core binary base path.
OASIS_CORE_ROOT_PATH ?= .oasis-core

# Runtime binary base path.
RUNTIME_ROOT_PATH ?= .runtime

# oasis-core cargo target directory.
OASIS_CARGO_TARGET_DIR := $(if $(CARGO_TARGET_DIR),$(CARGO_TARGET_DIR),$(OASIS_CORE_ROOT_PATH)/target)

# Runtime cargo target directory.
RUNTIME_CARGO_TARGET_DIR := $(if $(CARGO_TARGET_DIR),$(CARGO_TARGET_DIR),target)/default

# Extra build args.
EXTRA_BUILD_ARGS := $(if $(RELEASE),--release,)

# Check if we're running in an interactive terminal.
ISATTY := $(shell [ -t 0 ] && echo 1)

ifdef ISATTY
# Running in interactive terminal, OK to use colors!
MAGENTA = \e[35;1m
CYAN = \e[36;1m
RED = \e[31;1m
OFF = \e[0m

# Built-in echo doesn't support '-e'.
ECHO = /bin/echo -e
else
# Don't use colors if not running interactively.
MAGENTA = ""
CYAN = ""
RED = ""
OFF = ""

# OK to use built-in echo.
ECHO = echo
endif


.PHONY: \
	all \
	check check-tools check-oasis-core \
	symlink-artifacts \
	runtime test-client \
	genesis-update \
	clean clean-test-e2e \
	fmt \
	test test-unit test-e2e

all: check-tools runtime test-client
	@$(ECHO) "$(CYAN)*** Everything built successfully!$(OFF)"

check: check-tools check-oasis-core

check-tools:
	@which cargo-elf2sgxs >/dev/null || ( \
		$(ECHO) "$(RED)error:$(OFF) oasis-core-tools not installed (or not in PATH)" && \
		exit 1 \
	)

check-oasis-core:
	@test -x $(OASIS_CORE_ROOT_PATH)/go/oasis-node/oasis-node || ( \
		$(ECHO) "$(RED)error:$(OFF) oasis-node not found in $(OASIS_CORE_ROOT_PATH) (check OASIS_CORE_ROOT_PATH)" && \
		$(ECHO) "       Maybe you need to run \"make symlink-artifacts\"?" && \
		exit 1 \
	)

symlink-artifacts:
	@$(ECHO) "$(CYAN)*** Symlinking Oasis Core build artifacts...$(OFF)"
	@export OASIS_CARGO_TARGET_DIR=$(OASIS_CARGO_TARGET_DIR) && \
		scripts/symlink_artifacts.sh "$(OASIS_CORE_ROOT_PATH)" "$(OASIS_CORE_SRC_PATH)" "$(RUNTIME_ROOT_PATH)" $$(pwd)
	@$(ECHO) "$(CYAN)*** Symlinking done!$(OFF)"

runtime:
	@$(ECHO) "$(CYAN)*** Building example-runtime...$(OFF)"
	@CARGO_TARGET_DIR=$(RUNTIME_CARGO_TARGET_DIR) cargo build -p example-runtime $(EXTRA_BUILD_ARGS)

test-client:
	@$(ECHO) "$(CYAN)*** Building test-client...$(OFF)"
	@CARGO_TARGET_DIR=$(RUNTIME_CARGO_TARGET_DIR) cargo build -p test-client $(EXTRA_BUILD_ARGS)

test: test-unit test-e2e

test-unit: check-oasis-core
	@$(ECHO) "$(CYAN)*** Running unit tests...$(OFF)"
	@cargo test

test-e2e: check-oasis-core
	@$(ECHO) "$(CYAN)*** Running E2E tests...$(OFF)"
	@export OASIS_CORE_ROOT_PATH=$(OASIS_CORE_ROOT_PATH) RUNTIME_CARGO_TARGET_DIR=$(RUNTIME_CARGO_TARGET_DIR) && \
		scripts/test_e2e.sh

fmt:
	@cargo fmt

clean:
	@$(ECHO) "$(CYAN)*** Cleaning up...$(OFF)"
	@cargo clean

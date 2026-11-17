SHELL := /usr/bin/env bash
.DEFAULT_GOAL := help

.PHONY: build config help lint verify

config: ## Validate the resolved Docker Compose model.
	docker compose config --quiet

build: config ## Build the pinned verification toolchain.
	docker compose build verify

lint: verify ## Run all repository validation.

verify: build ## Run the same checks used by GitHub Actions.
	docker compose run --rm verify

help: ## Show available targets.
	@awk 'BEGIN {FS = ":.*## "; printf "Usage: make <target>\n\nTargets:\n"} /^[a-zA-Z_-]+:.*## / {printf "  %-12s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

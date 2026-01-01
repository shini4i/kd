.DEFAULT_GOAL := help

.PHONY: help
help: ## Print this help
	@echo "Usage: make [target]"
	@grep -E '^[a-z.A-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: check-deps
check-deps: ## Check that required dependencies are installed
	@command -v kubectl >/dev/null 2>&1 || { echo "Error: kubectl is required but not installed"; exit 1; }
	@command -v yq >/dev/null 2>&1 || { echo "Error: yq is required but not installed"; exit 1; }
	@command -v bats >/dev/null 2>&1 || { echo "Error: bats is required but not installed"; exit 1; }

.PHONY: lint
lint: ## Run shellcheck on all bash scripts
	@echo "===> Running shellcheck..."
	@shellcheck src/kd.sh completion/_kd.bash

.PHONY: prepare
prepare: ## Prepare test secrets (idempotent)
	@echo "===> Preparing test secrets..."
	@kubectl create ns example-ns 2>/dev/null || true
	@kubectl create secret generic example-secret --from-literal=example=provided -n example-ns 2>/dev/null || true
	@kubectl config set-context --current --namespace=default
	@kubectl create secret generic example-secret --from-literal=example=not-provided 2>/dev/null || true
	@kubectl create secret generic multi-key-secret --from-literal=key1=value1 --from-literal=key2=value2 --from-literal=key3=value3 2>/dev/null || true
	@kubectl create secret generic special-secret --from-literal='key=value with spaces' 2>/dev/null || true

.PHONY: test
test: check-deps ## Run tests
	@echo "===> Running tests..."
	@bats test

.PHONY: ci-test
ci-test: prepare test ## Run tests in CI

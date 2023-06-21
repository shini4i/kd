.DEFAULT_GOAL := help

.PHONY: help
help: ## Print this help
	@echo "Usage: make [target]"
	@grep -E '^[a-z.A-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: prepare
prepare: ## Prepare test secrets
	@echo "===> Preparing test secrets..."
	@kubectl create ns example-ns
	@kubectl create secret generic example-secret --from-literal=example=provided -n example-ns
	@kubectl config set-context --current --namespace=default
	@kubectl create secret generic example-secret --from-literal=example=not-provided

.PHONY: test
test: ## Run tests
	@echo "===> Running tests..."
	@bats test

.PHONY: ci-test
ci-test: prepare test ## Run tests in CI

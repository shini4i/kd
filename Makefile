.DEFAULT_GOAL := test

.PHONY: prepare_test_secrets
prepare_test_secrets: ## Prepare test secrets
	@echo "===> Preparing test secrets..."
	@kubectl create ns example-ns
	@kubectl create secret generic example-secret --from-literal=example=provided -n example-ns
	@kubectl config set-context --current --namespace=default
	@kubectl create secret generic example-secret --from-literal=example=not-provided

.PHONY: test
test: prepare_test_secrets ## Run tests
	@echo "===> Running tests..."
	@bats test

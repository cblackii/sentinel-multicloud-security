OPA_VERSION ?= 1.21.1
OPA_IMAGE := openpolicyagent/opa:$(OPA_VERSION)-static

.PHONY: policy-check policy-format policy-test

policy-check: policy-format policy-test

policy-format:
	docker run --rm -v "$(CURDIR):/workspace" --workdir /workspace $(OPA_IMAGE) fmt --fail --list policies tests/policies

policy-test:
	docker run --rm -v "$(CURDIR):/workspace" --workdir /workspace $(OPA_IMAGE) test policies tests/policies --verbose

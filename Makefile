# VARIABLES
export PATH := /snap/bin:$(PATH)
export CHARM_NAME_CENTOS := ntp-centos
export CHARM_STORE_GROUP := erik-lonroth
export CHARM_BUILD_DIR := ./builds
export CHARM_PUSH_RESULT := charm-store-push-result.txt
# TARGETS

lint: ## Run linter
	echo "No lint"

smoke-test: build ## Run smoke tests
	echo "No smoke"

integration-test: build ## Run integration tests
	echo "No integration-tests"

build: clean ## Build charm
	mkdir -p $(CHARM_BUILD_DIR)/$(CHARM_NAME_CENTOS)
	cp -r src/* $(CHARM_BUILD_DIR)/$(CHARM_NAME_CENTOS)
	charm proof $(CHARM_BUILD_DIR)/$(CHARM_NAME_CENTOS)

push: build ## Push and release charm to edge channel on charm store
	# See bug for why we can't push straight to edge
	# https://github.com/juju/charmstore-client/issues/146
	charm push $(CHARM_BUILD_DIR)/$(CHARM_NAME_CENTOS) cs:~$(CHARM_STORE_GROUP)/$(CHARM_NAME_CENTOS) > $(CHARM_PUSH_RESULT)
	cat $(CHARM_PUSH_RESULT)
	awk 'NR==1{print $$2}' $(CHARM_PUSH_RESULT) | xargs -I{} charm release {} --channel edge

clean: ## Remove .tox and build dirs
	rm -rf $(CHARM_BUILD_DIR)
	rm -rf $(CHARM_DEPS_DIR)
	rm -rf $(CHARM_PUSH_RESULT)

# Display target comments in 'make help'
help:
	grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

# SETTINGS
# Use one shell for all commands in a target recipe
.ONESHELL:
# Set default goal
.DEFAULT_GOAL := help
# Use bash shell in Make instead of sh
SHELL := /bin/bash


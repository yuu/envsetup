.DEFAULT_GOAL := help
.PHONY: help mac linux homebrew

COMMAND_LIST := ${MAKEFILE_LIST}

# if .env file exists, including secret infomations
ifneq ("$(wildcard .env)","")
include .env
endif

help:
	@grep -E '^[0-9a-zA-Z_-]+:.*?## .*$$' ${COMMAND_LIST} | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

prepare: ## install homebrew
ifeq (, $(shell which brew))
	curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh | bash
endif
	brew install ansible

mac: ## run mac
	@ansible-playbook macos.yml

linux: ## run linux
	@ansible-playbook debian.yml

debug:
	@ansible-playbook macos.yml --tags "debug"

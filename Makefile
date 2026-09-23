.DEFAULT_GOAL := help
.PHONY: help mac linux homebrew nix-setup nix-bootstrap nix-darwin nix-linux nix-switch

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
	@ansible-playbook debian.yml --ask-pass --ask-become-pass

nix-setup: ## generate user.nix from current env
	@printf '{\n  username = "%s";\n  hostname = "%s";\n}\n' "$$USER" "$$(hostname -s)" > user.nix

nix-bootstrap: nix-setup ## bootstrap nix-darwin (first time only)
	sudo nix --extra-experimental-features "nix-command flakes" run nix-darwin/master#darwin-rebuild -- switch --flake .

nix-darwin: nix-setup ## apply nix-darwin configuration (macOS)
	sudo darwin-rebuild switch --flake .

nix-linux: nix-setup ## apply home-manager configuration (Linux)
	home-manager switch --flake .

nix-switch: nix-darwin ## apply nix-darwin configuration (alias)

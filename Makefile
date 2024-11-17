.PHONY: build fmt update

build:
	@darwin-rebuild switch --flake ~/.config/nix-darwin#mbpro

fmt:
	@nix fmt

update:
	@nix flake update

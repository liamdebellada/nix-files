.PHONY: build fmt

build:
	@darwin-rebuild switch --flake ~/.config/nix-darwin#mbpro

fmt:
	@nix fmt

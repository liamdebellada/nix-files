{
  description = "nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew, home-manager, ... }:
  let
    configuration = { pkgs, config, ... }: {
	
      nixpkgs.config.allowUnfree = true;

      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [
	  pkgs.neovim
	  pkgs.mkalias
	  pkgs.obsidian
          pkgs.iterm2
	  pkgs.google-chrome
	  pkgs.ripgrep
	  pkgs.eza
	  pkgs.fzf
	  pkgs.kubectl
	  pkgs.fnm
	  pkgs.gh
	  pkgs.sops
        ];

	homebrew = {
	  enable = true;
	  masApps = {
	    "Xcode" = 497799835;
	  };
	  onActivation.autoUpdate = true;
	  onActivation.upgrade = true;
	  onActivation.cleanup = "zap";
	};

	system.activationScripts.applications.text = let
	  env = pkgs.buildEnv {
	    name = "system-applications";
	    paths = config.environment.systemPackages;
	    pathsToLink = "/Applications";
	  };
	in
	  pkgs.lib.mkForce ''
	  # Set up applications.
	  echo "setting up /Applications..." >&2
	  rm -rf /Applications/Nix\ Apps
	  mkdir -p /Applications/Nix\ Apps
	  find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
	  while read -r src; do
	    app_name=$(basename "$src")
	    echo "copying $src" >&2
	    ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
	  done
	      '';

      users.users.liamdebell.home = "/Users/liamdebell";
      nix.configureBuildUsers = true;

      system.defaults = {
        dock.persistent-apps = [
          "${pkgs.obsidian}/Applications/Obsidian.app"
          "${pkgs.iterm2}/Applications/iTerm2.app"
          "${pkgs.google-chrome}/Applications/Google Chrome.app"
        ];
	dock.show-recents = false;
	dock.persistent-others = [];
	dock.orientation = "left";
        dock.autohide = true;
	loginwindow.GuestEnabled = false;
        NSGlobalDomain.AppleInterfaceStyle = "Dark";
        NSGlobalDomain."com.apple.swipescrolldirection" = false;
      };

      # Auto upgrade nix package and the daemon service.
      services.nix-daemon.enable = true;
      # nix.package = pkgs.nix;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#simple
    darwinConfigurations."mbpro" = nix-darwin.lib.darwinSystem rec {
      specialArgs = { inherit inputs; };
      modules = [
        configuration
	nix-homebrew.darwinModules.nix-homebrew
	{
	  nix-homebrew = {
            # Install Homebrew under the default prefix
            enable = true;

            # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
            enableRosetta = true;

            # User owning the Homebrew prefix
            user = "liamdebell";
          };
	}
	home-manager.darwinModules.home-manager
	{
	  home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.liamdebell = import ./home.nix;
	  home-manager.extraSpecialArgs = specialArgs;
	}
      ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."mbpro".pkgs;
  };
}

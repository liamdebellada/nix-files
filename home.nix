{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  sops = {
    age.keyFile = "/Users/liamdebell/.config/sops/age/keys.txt"; # must have no password!
    # It's also possible to use a ssh key, but only when it has no password:
    #age.sshKeyPaths = [ "/home/user/path-to-ssh-key" ];
    defaultSopsFile = ./secrets/secrets.yaml;
    secrets.env = {
      format = "dotenv";
      key = "";
      sopsFile = ./secrets/secrets.env;
      path = "/Users/liamdebell/.env";
    };

    secrets.kubeconfig = {
      format = "yaml";
      key = "";
      sopsFile = ./secrets/kubeconfig.yaml;
      path = "/Users/liamdebell/.kube/config";
      mode = "600";
    };
  };

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "liamdebell";
  home.homeDirectory = "/Users/liamdebell";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.11";

  home.file = {
    ".zshrc".source = ./zsh/.zshrc;
  };

  programs.git = {
    enable = true;
    userName = "liamdebellada";
    userEmail = "liamdebell11@gmail.com";
  };

  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
    settings.git_protocol = "ssh";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
    matchBlocks = {
      "github.com" = {
        identityFile = "/Users/liamdebell/.ssh/id_ed25519";
      };
    };
  };

  programs.zsh = {
    enable = true;
    plugins = [
      {
        name = "zsh-history-substring-search";
        file = "zsh-history-substring-search.plugin.zsh";
        src = builtins.fetchGit {
          url = "https://github.com/zsh-users/zsh-history-substring-search";
          rev = "87ce96b1862928d84b1afe7c173316614b30e301";
        };
      }
      {
        name = "zsh-autosuggestions";
        file = "zsh-autosuggestions.plugin.zsh";
        src = builtins.fetchGit {
          url = "https://github.com/zsh-users/zsh-autosuggestions";
          rev = "c3d4e576c9c86eac62884bd47c01f6faed043fc5";
        };
      }
    ];
  };
}

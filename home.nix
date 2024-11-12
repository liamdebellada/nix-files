{ config, pkgs, lib, ... }:

{
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
  home.stateVersion = "24.05";

  home.file = {
    ".zshrc".source = ./zsh/.zshrc;
  };

  # iterm2 is not easy to configure, so copying the plist to "~/Library/Preferences" is a bit of a hack.
  home.activation.copy-iterm2-plist = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    cp ~/.config/nix-darwin/iterm2/com.googlecode.iterm2.plist ~/Library/Preferences/com.googlecode.iterm2.plist
  '';

  #programs.git = {
  #  enable = true;
  #  userName = "liamdebellada";
  #  userEmail = "liamdebell11@gmail.com";
  #};

  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
    settings.git_protocol = "ssh";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}


{ pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "enrico";
  home.homeDirectory = "/Users/enrico";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  home.packages = [
    # Mac tools
    pkgs.aldente
    pkgs.monitorcontrol

    # Dev tools
    pkgs.tmux
    pkgs.nodejs_20
    pkgs.mongodb-tools
    pkgs.tokei
    pkgs.just
    pkgs.thefuck
    pkgs.tree
    pkgs.watchexec

    pkgs.cargo
    pkgs.stripe-cli

    pkgs.nodePackages.nodemon
    pkgs.nodePackages.purs-tidy

    pkgs.elmPackages.elm
    pkgs.elmPackages.elm-format
    pkgs.elmPackages.elm-test-rs

    # Blogging
    pkgs.zola

    # Misc
    pkgs.asciiquarium-transparent

    # Nix
    pkgs.nixfmt
    pkgs.nil
  ];

  nixpkgs.config.allowUnfree = true;

  home.file = { };

  home.sessionVariables = { };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}

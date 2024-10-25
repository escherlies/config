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
  home.stateVersion = "24.05";

  home.packages = with pkgs; [
    # Mac tools
    aldente
    monitorcontrol
    pika # Color Picker

    # Apps
    ncdu # Disk usage analyzer with an ncurses interface

    # Dev tools
    tmux
    nodejs_20
    mongodb-tools
    tokei
    just
    thefuck
    tree
    watchexec
    bash # pre-installed bash is too old
    coreutils
    git-lfs

    cargo
    stripe-cli

    nodePackages.nodemon
    # nodePackages.purs-tidy

    # elmPackages.elm
    # elmPackages.elm-format
    # elmPackages.elm-test-rs

    # Blogging
    zola

    # Misc
    asciiquarium-transparent

    # Nix
    nixfmt-rfc-style
    nil

    # Misc
    bun
    caddy
    git
    yarn
    nixos-rebuild
    difftastic
  ];

  nixpkgs.config.allowUnfree = true;

  home.file = { };

  home.sessionVariables = { };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

}

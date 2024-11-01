{ pkgs, ... }:

{
  # Enable Micro :-)
  programs.micro = {
    enable = true;
    settings = {
      colorscheme = "atom";
      colorcolumn = 80;
    };
  };

}

{ pkgs, ... }:

{
  # Enable Micro :-)
  programs.micro = {
    enable = true;
    settings = {
      colorscheme = "cmc-16";
      colorcolumn = 80;
    };
  };

}

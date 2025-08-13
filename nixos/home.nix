{ config, pkgs, ... }:

let
    myAliases = {
      la = "ls -all";
    };
in
{
  home.username = "test";
  home.homeDirectory = "/home/test";

  programs.home-manager.enable = true;
  home.stateVersion = "25.05"; # Do not change

  home.packages = [
  ];

  home.file = {
  };

  home.sessionVariables = {
    EDITOR = "vim";
  };

  programs.bash = {
    enable = true;
    shellAliases = myAliases;
  };

  programs.zsh = {
    enable = true;
    shellAliases = myAliases;
  };
}

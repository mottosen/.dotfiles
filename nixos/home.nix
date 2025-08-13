{ config, pkgs, ... }:

{
  home.username = "test";
  home.homeDirectory = "/home/test";

  home.stateVersion = "25.05"; # Do not change

  home.packages = [
  ];

  home.file = {
  };

  home.sessionVariables = {
    EDITOR = "vim";
  };

  programs.home-manager.enable = true;
}

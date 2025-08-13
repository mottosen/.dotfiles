{ config, pkgs, ... }:

{
  imports = [
    ./sh-module.nix
  ];

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
}

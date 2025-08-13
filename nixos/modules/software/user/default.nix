{ config, pkgs, ... }:

{
  imports = [
    ./shell
  ];

  options = {};

  config = {
    home.username = "test";
    home.homeDirectory = "/home/test";

    programs.home-manager.enable = true;
    home.stateVersion = "25.05"; # Do not change

    home.packages = with pkgs; [];

    home.file = {};

    home.sessionVariables = {
      EDITOR = "vim";
    };
  };
}

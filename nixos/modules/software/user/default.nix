{ config, pkgs, ... }:

{
  imports = [
    ../../../profiles
    ./shell
  ];

  # Home-manager general
  programs.home-manager.enable = true;
  home = {
    stateVersion = "25.05"; # Do not change
    username = config.userSettings.username;
    homeDirectory = "/home/" + config.userSettings.username;
    packages = with pkgs; [];
    file = {};
  };
}

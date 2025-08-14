{ config, pkgs, ... }:

let
  font = config.userSettings.font;
in
{
  imports = [
    ../../../profiles
    ./shell
    ./terminal
  ];

  # Home-manager general
  programs.home-manager.enable = true;
  home = {
    stateVersion = "25.05"; # Do not change
    username = config.userSettings.username;
    homeDirectory = "/home/" + config.userSettings.username;
    packages = with pkgs; [
      nerd-fonts."${font}"
    ];
    file = {};
  };

  fonts.fontconfig.enable = true;
  xdg.enable = true;
}

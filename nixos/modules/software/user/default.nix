{ config, pkgs, ... }:

let
  font = config.userSettings.font;
in
{
  imports = [
    ../../../profiles
    ./shell
    ./terminal
    ./multiplexor
    ./fastfetch
    ./editor
    ./windowManager
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
  };

  fonts.fontconfig.enable = true;
}

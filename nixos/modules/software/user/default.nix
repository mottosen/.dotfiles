{ config, pkgs, ... }:

{
  imports = [
    ./shell
  ];

  # Home-manager general
  programs.home-manager.enable = true;
  home = {
    stateVersion = "25.05"; # Do not change
    username = "test"; # TODOTODO: variable
    homeDirectory = "/home/test"; # TODOTODO: variable
    packages = with pkgs; [];
    file = {};
  };
}

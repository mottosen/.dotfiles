{ config, pkgs, lib, ... }:

{
  config = lib.mkIf (config.userSettings.shell == "zsh") {
    programs.zsh = {
      enable = true;
      shellAliases = config.userSettings.shellAliases;
    };
  };
}

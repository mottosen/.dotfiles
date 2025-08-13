{ config, lib, ... }:

{
  config = lib.mkIf (config.userSettings.defaultShell == "zsh") {
    programs.zsh = {
      enable = true;
      shellAliases = config.userSettings.shellAliases;
    };
  };
}

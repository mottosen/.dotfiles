{ config, lib, ... }:

{
  config = lib.mkIf (config.userSettings.defaultShell == "bash") {
    programs.bash = {
      enable = true;
      shellAliases = config.userSettings.shellAliases;
    };
  };
}

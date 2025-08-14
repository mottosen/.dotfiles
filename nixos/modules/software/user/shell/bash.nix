{ config, lib, ... }:

{
  config = lib.mkIf (config.userSettings.shell == "bash") {
    programs.bash = {
      enable = true;
      shellAliases = config.userSettings.shellAliases;
    };
  };
}

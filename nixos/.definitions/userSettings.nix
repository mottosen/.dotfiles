{ config, lib, pkgs, ... }:

{
  options = {
    userSettings = {
      defaultShell = lib.mkOption {
        description = "Default Shell to use.";
        type = lib.types.nonEmptyStr;
        default = "zsh";
      };

      shellAliases = lib.mkOption {
        description = "Shell aliases to be set for the user.";
        type = lib.types.anything;
        default = {
          la = "ls -all";
        };
      };
    };
  };
}

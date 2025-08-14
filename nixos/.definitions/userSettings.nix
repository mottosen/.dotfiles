{ config, lib, pkgs, ... }:

{
  options = {
    userSettings = {
      username = lib.mkOption {
        description = "Default Shell to use.";
        type = lib.types.nonEmptyStr;
        default = "bash";
      };

      name = lib.mkOption {
        description = "Default Shell to use.";
        type = lib.types.nonEmptyStr;
        default = "bash";
      };

      email = lib.mkOption {
        description = "Default Shell to use.";
        type = lib.types.nonEmptyStr;
        default = "bash";
      };

      dotfilesDir = lib.mkOption {
        description = "Default Shell to use.";
        type = lib.types.nonEmptyStr;
        default = "bash";
      };

      windowManager = lib.mkOption {
        description = "Default Shell to use.";
        type = lib.types.nonEmptyStr;
        default = "bash";
      };

      browser = lib.mkOption {
        description = "Default Shell to use.";
        type = lib.types.nonEmptyStr;
        default = "bash";
      };

      terminal = lib.mkOption {
        description = "Default Shell to use.";
        type = lib.types.nonEmptyStr;
        default = "bash";
      };

      font = lib.mkOption {
        description = "Default Shell to use.";
        type = lib.types.nonEmptyStr;
        default = "bash";
      };

      editor = lib.mkOption {
        description = "Default Shell to use.";
        type = lib.types.nonEmptyStr;
        default = "bash";
      };

      spawnEditor = lib.mkOption {
        description = "Default Shell to use.";
        type = lib.types.nonEmptyStr;
        default = "bash";
      };

      shellAliases = lib.mkOption {
        description = "Shell aliases to be set for the user.";
        type = lib.types.anything;
        default = {};
      };
    };
  };
}

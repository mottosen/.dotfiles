{ config, lib, pkgs, ... }:

{
  options = {
    userSettings = {
      username = lib.mkOption {
        description = "Name of system user.";
        type = lib.types.nonEmptyStr;
        default = "no-set";
      };

      name = lib.mkOption {
        description = "Real name.";
        type = lib.types.nonEmptyStr;
        default = "no-set";
      };

      email = lib.mkOption {
        description = "Email for eg. git.";
        type = lib.types.nonEmptyStr;
        default = "no-set";
      };

      dotfilesDir = lib.mkOption {
        description = "Path of .dotfiles directory.";
        type = lib.types.path;
        default = "../../../.dotfiles";
      };

      windowManager = lib.mkOption {
        description = "Windor Manager to use.";
        type = lib.types.str;
        default = "";
      };

      browser = lib.mkOption {
        description = "Browser to use.";
        type = lib.types.str;
        default = "";
      };

      terminal = lib.mkOption {
        description = "Terminal to use.";
        type = lib.types.str;
        default = "";
      };

      font = lib.mkOption {
        description = "Font to use.";
        type = lib.types.str;
        default = "";
      };

      editor = lib.mkOption {
        description = "Editor to use.";
        type = lib.types.nonEmptyStr;
        default = "vim";
      };

      spawnEditor = lib.mkOption {
        description = "Command to spawn the right editor.";
        type = lib.types.nonEmptyStr;
        default =
          if ((config.systemSettings.editor == "vim") ||
              (config.systemSettings.editor == "nvim")) then
                "exec " + config.systemSettings.term + " -e " + config.systemSettings.editor
          else
            config.systemSettings.editor;
      };

      shell = lib.mkOption {
        description = "Shell to use.";
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

{ config, lib, ... }:

{
  imports = [
    ../../.definitions
  ];

  config = lib.mkIf (config.systemSettings.profile == "vm") {
    systemSettings = {
      hostname = "nixos-vm";
      timezone = "Europe/Copenhagen";
    };

    userSettings = {
      username = "test";
      name = "test user";
      email = "test@vm.com";
      windowManager = "";
      browser = "";
      terminal = "";
      font = "";
      shell = "zsh";
      shellAliases = {
        la = "ls -al --color";
      };
    };
  };
}

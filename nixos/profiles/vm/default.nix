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
      username = "test"; # host mounted dir depends on this
      name = "test user";
      email = "test@vm.com";
      windowManager = "";
      browser = "";
      terminal = "wezterm";
      font = "fira-code";
      shell = "zsh";
      shellAliases = {
        la = "ls -al --color";
      };
    };
  };
}

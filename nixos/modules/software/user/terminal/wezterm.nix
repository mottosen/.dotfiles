{ config, pkgs, lib, ... }:

{
  config = lib.mkIf (config.userSettings.terminal == "wezterm") {
    programs.wezterm = {
      enable = true;
    };

    home.file."wezterm" = {
      target = ".config/wezterm/";
      source = config.userSettings.configFiles +
        "/wezterm/";
      recursive = true;
    };
  };
}

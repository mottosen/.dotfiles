{ config, pkgs, lib, ... }:

{
  config = lib.mkIf (config.userSettings.multiplexor == "zellij") {
    programs.zellij = {
      enable = true;
    };

    home.file."zellij" = {
      target = ".config/zellij/";
      source = 
        config.userSettings.configFiles +
        "/zellij/";
      recursive = true;
      force = true;
    };
  };
}

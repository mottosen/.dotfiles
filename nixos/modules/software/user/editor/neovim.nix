{ config, pkgs, lib, ... }:

{
  config = lib.mkIf (lib.elem config.userSettings.editor [ "vim" "nvim" ]) {
    programs.neovim = {
      enable = true;
      defaultEditor = true;
    };

    home.file."nvim" = {
      target = ".config/nvim/";
      source = 
        config.userSettings.configFiles +
        "/nvim/";
      recursive = true;
      force = true;
    };
  };
}

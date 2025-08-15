{ config, pkgs, lib, ... }:

{
  config = lib.mkIf (config.userSettings.shell == "zsh") {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      history = {
        size = 10000;
        save = 5000;
      };
      shellAliases = config.userSettings.shellAliases;

      initContent = ''
        eval "$(${pkgs.oh-my-posh}/bin/oh-my-posh init zsh \
          --config ${config.home.homeDirectory}/.dotfiles/.config/oh-my-posh/config.yaml)"
      '';
    };

    # oh-my-posh
    programs.oh-my-posh.enable = true;
    home.file."oh-my-posh" = {
      target = ".config/oh-my-posh/home.yaml";
      source = config.userSettings.configFiles +
        "/oh-my-posh/config.yaml";
      force = true;
    };
  };
}

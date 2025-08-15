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

      oh-my-zsh = {
        enable = true;
        #theme = "powerlevel10k/powerlevel10k";
        plugins = [
          "git"
          "sudo"
          "aws"
          "kubectl"
          "kubectx"
        ];
      };

      plugins = [
        { name = "zsh-autosuggestions";     src = pkgs.zsh-autosuggestions; }
        { name = "zsh-syntax-highlighting"; src = pkgs.zsh-syntax-highlighting; }
        { name = "zsh-completions";         src = pkgs.zsh-completions; }
        { name = "fzf-tab";                 src = pkgs.zsh-fzf-tab; }
      ];

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

    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
      options = [ "--cmd" "cd" ];
    };
  };
}

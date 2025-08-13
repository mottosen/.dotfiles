{ config, pkgs, ... }:

let
    myAliases = {
      la = "ls -all";
    };
in
{
  programs.bash = {
    enable = true;
    shellAliases = myAliases;
  };

  programs.zsh = {
    enable = true;
    shellAliases = myAliases;
  };
}

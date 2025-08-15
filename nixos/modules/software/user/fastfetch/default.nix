{ config, pkgs, ... }:

{
  imports = [
    ./squares.nix
  ];

  programs.fastfetch.enable = true;
}

{ config, pkgs, lib, ... }:

{
  programs.fastfetch.settings = {
    logo = {
      source = "nixos_small";
      padding = {
        right = 1;
      };
    };
    display = {
      color = {
          separator = "blue";
      };
      separator = " | ";
      constants = [
          ">-----------<+>---------------------------------------------<"
      ];
    };
    modules = [
      {
          type = "kernel";
          key = "   NixOS    ";
          keyColor = "magenta";
      }
      {
          type = "custom";
          format = "{$1}";
          outputColor = "separator";
      }
      {
          type = "uptime";
          key = "   Uptime   ";
          keyColor = "green";
      }
      {
          type = "shell";
          key = "   Shell    ";
          keyColor = "green";
      }
      {
          type = "terminal";
          key = "   Terminal ";
          keyColor = "green";
      }
      {
          type = "terminalfont";
          key = "   Font     ";
          keyColor = "green";
      }
      {
          type = "packages";
          key = "   Packages ";
          keyColor = "green";
      }
      {
          type = "custom";
          format = "{$1}";
          outputColor = "separator";
      }
      {
          type = "display";
          key = "   Display  ";
          keyColor = "cyan";
      }
      {
          type = "cpu";
          key = "   CPU      ";
          keyColor = "cyan";
      }
      {
          type = "gpu";
          key = "   GPU      ";
          keyColor = "cyan";
      }
      {
          type = "memory";
          key = "   RAM      ";
          keyColor = "cyan";
      }
      {
          type = "swap";
          key = "   SWAP     ";
          keyColor = "cyan";
      }
      {
          type = "disk";
          key = "   Disk     ";
          keyColor = "cyan";
      }
      {
          type = "battery";
          key = "   Battery  ";
          keyColor = "cyan";
      }
      {
          type = "custom";
          format = "{$1}";
          outputColor = "separator";
      }
      "break"
      {
          type = "colors";
          paddingLeft = 15;
      }
    ];
  };
}

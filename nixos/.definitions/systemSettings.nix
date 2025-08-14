{ config, lib, pkgs, ... }:

{
  options = {
    systemSettings = {
      profile = lib.mkOption {
        type = lib.types.nonEmptyStr;
        default = "vm";
      };
    };
  };
}

{ config, pkgs, profile, system, ... }:

{
  imports = [
    ../../.definitions
    ../../modules/hardware
    ../../modules/software/system
  ];

  systemSettings = {
    hostname = "vm";
    timezone = "Europe/Copenhagen";
  };
}

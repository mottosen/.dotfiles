{ config, ... }:

{
  imports = [
    ../../.definitions
    ../../modules/hardware
    ../../modules/software/system
  ];
}

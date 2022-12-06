{ config, pkgs, ... }:
{
  xdg.configFile = {
    "neofetch/config.conf" = {
      source = ./config/config.conf;
    };
  };
}

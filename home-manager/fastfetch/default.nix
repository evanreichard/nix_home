{ config, pkgs, ... }:
{
  xdg.configFile = {
    "fastfetch/config.jsonc" = {
      source = ./config/config.jsonc;
    };
  };
}

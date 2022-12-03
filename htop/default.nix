{ config, pkgs, ... }:

{
  xdg.configFile."htop/htoprc" = {
    source = ./config/htoprc;
  };
}

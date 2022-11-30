{ config, pkgs, ... }:

{
  xdg.configFile."iterm2/com.googlecode.iterm2.plist" = {
    source = ./config/com.googlecode.iterm2.plist;
  };
}


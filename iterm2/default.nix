{ config, pkgs, ... }:
let
  inherit (pkgs.lib) mkIf;
  inherit (pkgs.stdenv) isDarwin;
in
{
  xdg.configFile = mkIf isDarwin {
    "iterm2/com.googlecode.iterm2.plist" = {
      source = ./config/com.googlecode.iterm2.plist;
    };
  };
}

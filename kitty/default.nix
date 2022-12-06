{ config, pkgs, ... }:
let
  inherit (pkgs.lib) mkIf;
  inherit (pkgs.stdenv) isDarwin;
in
{
  xdg.configFile = mkIf isDarwin {
    "kitty/kitty.conf" = {
      source = ./config/kitty.conf;
    };
  };
}

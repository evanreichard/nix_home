{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "Evan Reichard";
    userEmail = "evan@reichard.io";
  };

}

{ config, pkgs, ... }:

{

  imports = [
    ./bash
    ./git
    ./nvim
    ./powerline
    ./readline
    ./tmux
  ];

  # Home Manager Config
  home.username = "evanreichard";
  home.homeDirectory = "/Users/evanreichard";
  home.stateVersion = "22.05";
  programs.home-manager.enable = true;

  # Global Packages
  home.packages = with pkgs; [
    bashInteractive
    htop
    k9s
    kubectl
    mosh
    neofetch
    nerdfonts
    python311
    tldr
  ];

  # Other Programs
  programs.jq.enable = true;
  programs.pandoc.enable = true;

}

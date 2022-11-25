{ config, pkgs, ... }:

{
  programs.powerline-go = {
    enable = true;
    modules = [
      "host"
      "cwd"
      "git"
      "docker"
      "venv"
    ];
  };
}

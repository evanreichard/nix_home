{ config, pkgs, ... }:

{
  programs.powerline-go = {
    enable = true;
    settings = {
      git-mode = "compact";
    };
    modules = [
      "host"
      "cwd"
      "git"
      "docker"
      "venv"
    ];
  };
}

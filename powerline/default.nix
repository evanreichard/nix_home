{ config, pkgs, ... }:

{
  programs.powerline-go = {
    enable = true;
    settings = {
      git-mode = "compact";
      theme = "gruvbox";
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

{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "Evan Reichard";
    includes = [
      {
        path = "~/.config/git/work";
        condition = "gitdir:~/Development/git/work/";
      }
      {
        path = "~/.config/git/personal";
        condition = "gitdir:~/Development/git/personal/";
      }
    ];
  };

  xdg.configFile = {

    # Copy Configuration
    git = {
      source = ./config;
      recursive = true;
    };

  };

}

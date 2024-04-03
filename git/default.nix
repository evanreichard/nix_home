{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "Evan Reichard";
    aliases = {
      lg = "log --graph --abbrev-commit --decorate --date=relative --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all -n 15";
    };
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
    extraConfig = {
      core = {
        autocrlf = "input";
        safecrlf = "true";
        excludesFile = "~/.config/git/.gitignore";
      };
      merge = {
        conflictstyle = "zdiff3";
      };
      push = {
        autoSetupRemote = true;
      };
    };
  };

  xdg.configFile = {

    # Copy Configuration
    git = {
      source = ./config;
      recursive = true;
    };

  };
}

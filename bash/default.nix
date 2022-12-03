{ config, pkgs, ... }:

{
  programs.bash = {
    enable = true;
    shellAliases = {
      grep = "grep --color";
    };
    profileExtra = ''
      set -o vi
      [ ! -z $TMUX ] || tmux a || tmux
      neofetch
    '';
  };

}

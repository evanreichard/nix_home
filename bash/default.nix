{ config, pkgs, ... }:

{
  programs.bash = {
    enable = true;
    shellAliases = {
      grep = "grep --color";
    };
    profileExtra = ''
      set -o vi
      bind "set show-mode-in-prompt on"
      [ ! -z $TMUX ] || tmux a || tmux
      neofetch
    '';
  };

}

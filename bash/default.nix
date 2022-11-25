{ config, pkgs, ... }:

{
  programs.bash = {
    enable = true;
    profileExtra =''
      set -o vi
      [ ! -z $TMUX ] || tmux a || tmux
      neofetch
    '';
  };

}

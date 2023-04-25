{ config, pkgs, ... }:

{
  programs.bash = {
    enable = true;
    shellAliases = {
      grep = "grep --color";
      ssh = "TERM=xterm-256color ssh";
    };
    profileExtra = ''
      SHELL="$BASH"
      set -o vi
      bind "set show-mode-in-prompt on"
      neofetch
    '';
  };

}

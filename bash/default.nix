{ config, pkgs, ... }:

{
  programs.bash = {
    enable = true;
    shellAliases = {
      grep = "grep --color";
    };
    profileExtra = ''
      SHELL="$BASH"
      set -o vi
      bind "set show-mode-in-prompt on"
      neofetch
    '';
  };

}

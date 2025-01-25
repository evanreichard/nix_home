{ config, pkgs, ... }:

{
  programs.readline = {
    enable = true;
    extraConfig = ''
      # Approximate VIM Dracula Colors
      set vi-ins-mode-string \1\e[01;38;5;23;48;5;231m\2 I \1\e[38;5;231;48;5;238m\2\1\e[0m\2
      set vi-cmd-mode-string \1\e[01;38;5;22;48;5;148m\2 C \1\e[38;5;148;48;5;238m\2\1\e[0m\2
    '';
  };

}

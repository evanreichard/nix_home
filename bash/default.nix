{ config, pkgs, ... }:

{
  programs.bash = {
    enable = true;
    shellAliases = {
      grep = "grep --color";
      ssh = "TERM=xterm-256color ssh";
      flush_dns = "sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder";
    };
    profileExtra = ''
      SHELL="$BASH"
      PATH=~/.bin:$PATH
      set -o vi
      bind "set show-mode-in-prompt on"
      neofetch
    '';
  };

}

{ config, pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    clock24 = true;
    shell = "${pkgs.bashInteractive}/bin/bash";
    plugins = with pkgs.tmuxPlugins; [
      yank
      cpu
      resurrect
      continuum
      {
        plugin = dracula;
        extraConfig = ''
          set -g @dracula-show-battery false
          set -g @dracula-show-powerline true
          set -g @dracula-refresh-rate 10
          set -g @dracula-military-time true
          set -g @dracula-plugins "battery cpu-usage ram-usage time"
        '';
      }
    ];

    extraConfig = ''
      # VIM, Prefix, Renumber
      setw -g mode-keys vi
      set-option -g prefix C-t
      set-option -g renumber-windows on

      # Maintain Directory
      bind '"' split-window -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"
      bind c new-window -c "#{pane_current_path}"

      # Set Colors
      # set -g default-terminal "screen-256color"
      # set-option -ga terminal-overrides ",xterm-256color:Tc"
    '';
  };
}

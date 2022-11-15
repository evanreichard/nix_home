{ config, pkgs, ... }:

{

  # Home Manager Config
  home.username = "evanreichard";
  home.homeDirectory = "/Users/evanreichard";
  home.stateVersion = "22.05";
  programs.home-manager.enable = true;

  # Global Packages
  home.packages = [
    pkgs.bashInteractive
    pkgs.htop
    pkgs.k9s
    pkgs.kubectl
    pkgs.mosh
    pkgs.neofetch
  ];

  # Other Programs
  programs.jq.enable = true;
  programs.pandoc.enable = true;

  # ----------------------
  # --------- git --------
  # ----------------------
  programs.git = {
    enable = true;
    userName = "Evan Reichard";
    userEmail = "evan@reichard.io";
  };

  # ----------------------
  # ------ readline ------
  # ----------------------
  programs.readline = {
    enable = true;
    extraConfig = ''
      # Show Prompt
      set show-mode-in-prompt on

      # Approximate VIM Dracula Colors
      set vi-ins-mode-string \1\e[01;38;5;23;48;5;231m\2 INS \1\e[38;5;231;48;5;238m\2\1\e[0m\2
      set vi-cmd-mode-string \1\e[01;38;5;22;48;5;148m\2 CMD \1\e[38;5;148;48;5;238m\2\1\e[0m\2
    '';
  };

  # ----------------------
  # -------- bash --------
  # ----------------------
  programs.bash = {
    enable = true;
    profileExtra =''
      set -o vi
      [ ! -z $TMUX ] || tmux a || tmux
      neofetch
    '';
  };

  # ----------------------
  # -------- tmux --------
  # ----------------------
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

    extraConfig = builtins.readFile ./extraConfig.tmux;

  };

  # ----------------------
  # ------- neovim -------
  # ----------------------
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    withNodeJs = true;
    withPython3 = true;

    plugins = with pkgs.vimPlugins; [
      coc-eslint
      coc-json
      coc-pyright
      coc-yaml
      dracula-vim
      lightline-vim
      vim-nix
    ];

    coc = {
      enable = true;
      package = pkgs.vimUtils.buildVimPluginFrom2Nix {
        pname = "coc.nvim";
        version = "2022-11-03";
        src = pkgs.fetchFromGitHub {
          owner = "neoclide";
          repo = "coc.nvim";
          rev = "5f52e41be1ff19ce1f1bd3307144e7d96703b7fd";
          sha256 = "0nm8jgdgxbdlvcpl12fs2fgxww5nizjpqd2ywm2n7ca0lsjpqcx0";
        };
        meta.homepage = "https://github.com/neoclide/coc.nvim/";
      };
    };

    extraConfig = builtins.readFile ./extraConfig.vim;
  };

  # ----------------------
  # ------ powerline -----
  # ----------------------
  programs.powerline-go = {
    enable = true;
    modules = [
      "host"
      "cwd"
      "git"
      "docker"
      "venv"
    ];
  };
}


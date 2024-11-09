{ config, pkgs, ... }:
let
  inherit (pkgs.lib.lists) subtractLists;
  unstable = import <nixpkgs-unstable> { };
in
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    withNodeJs = true;
    withPython3 = true;

    plugins = with pkgs.vimPlugins; [
      # ------------------
      # --- Completion ---
      # ------------------
      cmp-buffer # Buffer Word Completion
      cmp-cmdline # Command Line Completion
      cmp-nvim-lsp # Main LSP
      cmp-path # Path Completion
      cmp_luasnip # Snippets Completion
      friendly-snippets # Snippets
      lsp_lines-nvim # Inline Diagnostics
      luasnip # Snippets
      nvim-cmp # Completions
      nvim-lspconfig # LSP Config

      # -------------------
      # ----- Helpers -----
      # -------------------
      aerial-nvim # Code Outline
      comment-nvim # Code Comments
      diffview-nvim # Diff View
      gitsigns-nvim # Git Blame
      leap-nvim # Quick Movement
      markdown-preview-nvim # Markdown Preview
      neo-tree-nvim # File Explorer
      none-ls-nvim # Formatters
      numb-nvim # Peek / Jump to Lines
      nvim-autopairs # Automatically Close Pairs (),[],{}
      telescope-fzf-native-nvim # Faster Telescope
      telescope-nvim # Fuzzy Finder
      telescope-ui-select-nvim # UI
      toggleterm-nvim # Terminal Helper
      vim-nix # Nix Helpers
      which-key-nvim # Shortcut Helper

      # ------------------
      # --- Theme / UI ---
      # ------------------
      lualine-nvim # Bottom Line
      noice-nvim # UI Tweaks
      # nord-nvim # Theme
      melange-nvim # Theme
      nvim-notify # Noice Dependency
      nvim-web-devicons # Dev Icons

      # ------------------
      # --- Treesitter ---
      # ------------------
      nvim-treesitter-context
      nvim-treesitter.withAllGrammars

      # -------------------
      # ------- DAP -------
      # -------------------
      nvim-dap
      nvim-dap-go
      nvim-dap-ui

      # --------------------
      # -- NONE-LS EXTRAS --
      # --------------------
      (
        pkgs.vimUtils.buildVimPlugin {
          pname = "none-ls-extras.nvim";
          version = "2024-06-11";
          src = pkgs.fetchFromGitHub {
            owner = "nvimtools";
            repo = "none-ls-extras.nvim";
            rev = "336e84b9e43c0effb735b08798ffac382920053b";
            sha256 = "sha256-UtU4oWSRTKdEoMz3w8Pk95sROuo3LEwxSDAm169wxwk=";
          };
          meta.homepage = "https://github.com/nvimtools/none-ls-extras.nvim/";
        }
      )

      # -------------------
      # ----- Silicon -----
      # -------------------
      (
        pkgs.vimUtils.buildVimPlugin {
          pname = "silicon.lua";
          version = "2022-12-03";
          src = pkgs.fetchFromGitHub {
            owner = "mhanberg";
            repo = "silicon.lua";
            rev = "5ca462bee0a39b058786bc7fbeb5d16ea49f3a23";
            sha256 = "0vlp645d5mmii513v72jca931miyrhkvhwb9bfzhix1199zx7vi2";
          };
          meta.homepage = "https://github.com/mhanberg/silicon.lua/";
        }
      )

      # -------------------
      # ------- LLM -------
      # -------------------
      (
        pkgs.vimUtils.buildVimPlugin {
          pname = "llm.nvim";
          version = "2024-05-25";
          src = pkgs.fetchFromGitHub {
            owner = "David-Kunz";
            repo = "gen.nvim";
            rev = "bd19cf584b5b82123de977b44105e855e61e5f39";
            sha256 = "sha256-0AEB6im8Jz5foYzmL6KEGSAYo48g1bkFpjlCSWT6JeE=";
          };
          meta.homepage = "https://github.com/David-Kunz/gen.nvim/";
        }
      )

    ];

    extraPackages = with pkgs; [
      # Telescope Dependencies
      fd
      ripgrep
      tree-sitter

      # LSP Dependencies
      go
      golangci-lint
      golangci-lint-langserver
      gopls
      lua-language-server
      nodePackages.eslint
      unstable.eslint_d
      nodePackages.pyright
      nodePackages.svelte-language-server
      nodePackages.typescript
      nodePackages.typescript-language-server
      nodePackages.vscode-langservers-extracted

      # Formatters
      luaformatter
      nixpkgs-fmt
      nodePackages.prettier
      sqlfluff
      stylua

      # Silicon
      silicon
    ];

    extraConfig = ":luafile ~/.config/nvim/lua/init.lua";
  };


  xdg.configFile = {
    # Copy Configuration
    nvim = {
      source = ./config;
      recursive = true;
    };

    # Generate Nix Vars
    "nvim/lua/nix-vars.lua".text = ''
      local nix_vars = {
        gopls = "${pkgs.gopls}/bin/gopls",
        luals = "${pkgs.lua-language-server}/bin/lua-language-server",
        sveltels = "${pkgs.nodePackages.svelte-language-server}/bin/svelteserver",
        tsls = "${pkgs.nodePackages.typescript-language-server}/bin/typescript-language-server",
        golintls = "${pkgs.golangci-lint-langserver}/bin/golangci-lint-langserver",
        vscls = "${pkgs.nodePackages.vscode-langservers-extracted}",
      }
      return nix_vars
    '';
  };
}

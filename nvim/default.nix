{ config, pkgs, ... }:
let
  inherit (pkgs.lib.lists) subtractLists;
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

      # ------------------
      # ----- Helpers ----
      # ------------------
      aerial-nvim # Code Outline
      comment-nvim # Code Comments
      diffview-nvim # Diff View
      leap-nvim # Quick Movement
      neo-tree-nvim # File Explorer
      null-ls-nvim # Formatters
      numb-nvim # Peek / Jump to Lines
      nvim-autopairs # Automatically Close Pairs (),[],{}
      telescope-fzf-native-nvim # Faster Telescope
      telescope-nvim # Fuzzy Finder
      toggleterm-nvim # Terminal Helper
      vim-nix # Nix Helpers
      which-key-nvim # Shortcut Helper

      # ------------------
      # --- Theme / UI ---
      # ------------------
      lualine-nvim # Bottom Line
      noice-nvim # UI Tweaks
      nord-nvim # Theme
      nvim-web-devicons # Dev Icons

      # ------------------
      # --- Treesitter ---
      # ------------------
      (
        nvim-treesitter.withPlugins (
          # Exclude Outdated Packages (Causes Issues)
          plugins: with pkgs; subtractLists [
            tree-sitter-grammars.tree-sitter-bash
            tree-sitter-grammars.tree-sitter-kotlin
          ]
            tree-sitter.allGrammars
        )
      )

      # ------------------
      # ----- Silicon ----
      # ------------------
      (
        pkgs.vimUtils.buildVimPluginFrom2Nix {
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

      # ------------------
      # ------ Duck ------
      # ------------------
      # (
      #   pkgs.vimUtils.buildVimPluginFrom2Nix {
      #     pname = "duck.nvim";
      #     version = "2022-12-06";
      #     src = pkgs.fetchFromGitHub {
      #       owner = "tamton-aquib";
      #       repo = "duck.nvim";
      #       rev = "b1a3b4e52eec886bf4ce5ed692a2162d504d9632";
      #       sha256 = "0clc9s175mjzrkcjmwhl60fycdxgn24wkhcggaw1gsfspnlizr8z";
      #     };
      #     meta.homepage = "https://github.com/tamton-aquib/duck.nvim/";
      #   }
      # )

    ];

    extraPackages = with pkgs; [

      # Telescope Dependencies
      ripgrep
      fd

      # LSP Dependencies
      nodePackages.pyright
      nodePackages.typescript
      nodePackages.typescript-language-server
      nodePackages.vscode-langservers-extracted
      gopls

      # Formatters
      luaformatter
      nixpkgs-fmt
      nodePackages.prettier
      sqlfluff

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
        tsserver = "${pkgs.nodePackages.typescript-language-server}/bin/typescript-language-server",
        tslib = "${pkgs.nodePackages.typescript}/lib/node_modules/typescript/lib/",
        vscodels = "${pkgs.nodePackages.vscode-langservers-extracted}",
        gopls = "${pkgs.gopls}",
      }
      return nix_vars
    '';

  };
}

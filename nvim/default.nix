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
            owner = "0oAstro";
            repo = "silicon.lua";
            rev = "8db5682c9c13d6de584551c4b2b9982709f05610";
            sha256 = "0148l59wrffmfw4xya0l1ys277hgrm41wspgp0ns2dddsr11mwav";
          };
          meta.homepage = "https://github.com/0oAstro/silicon.lua/";
        }
      )

    ];

    extraPackages = with pkgs; [

      # Telescope Dependencies
      ripgrep
      fd

      # LSP Dependencies
      nodePackages.pyright
      nodePackages.typescript
      nodePackages.typescript-language-server
      nodePackages.vscode-html-languageserver-bin

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
        htmlserver = "${pkgs.nodePackages.vscode-html-languageserver-bin}/bin/html-languageserver",
        tsserver = "${pkgs.nodePackages.typescript-language-server}/bin/typescript-language-server",
        tslib = "${pkgs.nodePackages.typescript}/lib/node_modules/typescript/lib/",
      }
      return nix_vars
    '';

  };
}

{ config, pkgs, ... }:

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
      cmp-buffer      # Buffer Word Completion
      cmp-cmdline     # Command Line Completion
      cmp-nvim-lsp    # Main LSP
      cmp-path        # Path Completion
      cmp-vsnip       # Snippets
      lsp_lines-nvim  # Inline Diagnostics
      nvim-cmp        # Completions
      nvim-lspconfig  # LSP Config

      # ------------------
      # ----- Helpers ----
      # ------------------
      aerial-nvim     # Code Outline
      comment-nvim    # Code Comments
      diffview-nvim   # Diff View
      numb-nvim       # Peek / Jump to Lines
      nvim-autopairs  # Automatically Close Pairs (),[],{}
      nvim-tree-lua   # File Explorer
      telescope-nvim  # Fuzzy Finder
      vim-nix         # Nix Helpers

      # ------------------
      # --- Theme / UI ---
      # ------------------
      embark-vim        # Theme
      lightline-vim     # Bottom Line
      noice-nvim        # UI Tweaks
      nvim-web-devicons # Dev Icons

      # ------------------
      # --- Treesitter ---
      # ------------------
      (
        nvim-treesitter.withPlugins (
          plugins: with pkgs.tree-sitter-grammars; [
            # tree-sitter-bash            # Incompatibility (Prevents Noice Highlighting)
            tree-sitter-lua
            tree-sitter-markdown
            tree-sitter-markdown-inline
            tree-sitter-regex
            tree-sitter-vim
          ]
        )
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

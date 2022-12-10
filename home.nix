{ config, lib, pkgs, ... }:
let
  inherit (pkgs.lib) mkIf optionals;
  inherit (pkgs.stdenv) isLinux isDarwin;
in
{

  imports = [
    ./bash
    ./direnv
    ./git
    ./htop
    ./kitty
    ./neofetch
    ./nvim
    ./powerline
    ./readline
  ];

  # Home Manager Config
  home.username = "evanreichard";
  home.homeDirectory = "/Users/evanreichard";
  home.stateVersion = "22.05";
  programs.home-manager.enable = true;

  # Global Packages
  home.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "Meslo" ]; })
    bashInteractive
    google-cloud-sdk
    htop
    imagemagick
    k9s
    kubectl
    mosh
    neofetch
    pre-commit
    python311
    tldr
  ] ++ optionals isDarwin [
    kitty
  ] ++ optionals isLinux [ ];

  # Misc Programs
  programs.jq.enable = true;
  programs.pandoc.enable = true;

  # Misc Configuration
  home.file.".sqliterc".text = ''
    .headers on
    .mode column
  '';

  # Darwin Spotlight Indexing Hack
  home.activation = mkIf isDarwin {
    copyApplications =
      let
        apps = pkgs.buildEnv {
          name = "home-manager-applications";
          paths = config.home.packages;
          pathsToLink = "/Applications";
        };
      in
      lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        baseDir="$HOME/Applications/Home Manager Apps"
        if [ -d "$baseDir" ]; then
          rm -rf "$baseDir"
        fi
        mkdir -p "$baseDir"
        for appFile in ${apps}/Applications/*; do
          target="$baseDir/$(basename "$appFile")"
          $DRY_RUN_CMD cp ''${VERBOSE_ARG:+-v} -fHRL "$appFile" "$baseDir"
          $DRY_RUN_CMD chmod ''${VERBOSE_ARG:+-v} -R +w "$target"
        done
      '';
  };

  # Darwin Spotlight Indexing Hack
  disabledModules = [ "targets/darwin/linkapps.nix" ];
}

# Nix Home Manager Configuration

## Upgrade

```
# Update System Channels
sudo nix-channel --add https://nixos.org/channels/nixpkgs-23.05-darwin nixpkgs
sudo nix-channel --update

# Update Home Manager
nix-channel --add https://github.com/nix-community/home-manager/archive/release-23.05.tar.gz home-manager
nix-channel --update

# Build Home Manager
home-manager switch
```

## Clean Garbage

NOTE: This will remove previous generations

```
nix-collect-garbage --delete-old
sudo nix-collect-garbage --delete-old
```

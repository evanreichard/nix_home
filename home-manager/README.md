# Nix Home Manager Configuration

## Upgrade

```bash
# Update System Channels
sudo nix-channel --add https://nixos.org/channels/nixpkgs-24.11-darwin nixpkgs
sudo nix-channel --update

# Update Home Manager
nix-channel --add https://github.com/nix-community/home-manager/archive/release-24.11.tar.gz home-manager
nix-channel --update

# Link Repo
ln -s /Users/evanreichard/Development/git/personal/nix/home-manager ~/.config/home-manager

# Build Home Manager
home-manager switch
```

## Clean Garbage

NOTE: This will remove previous generations

```bash
sudo nix-collect-garbage --delete-old
nix-collect-garbage --delete-old
```

## OS Update

`/etc/bashrc` may get overridden. To properly load Nix, prepend the following:

```bash
# Nix
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi
# End Nix
```

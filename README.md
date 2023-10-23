# Nix Home Manager Configuration

## Upgrade

```bash
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

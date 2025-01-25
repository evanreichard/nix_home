# Deploy NixOS

## Copy Config

```bash
scp -r * nixos@10.10.10.10:/tmp/
```

## Partition Drives

```bash
# WARNING: Be sure to check drive mappings
sudo fdisk -l

# Partition Disk
sudo nix \
    --experimental-features "nix-command flakes" \
    run github:nix-community/disko -- \
    --mode disko \
    --flake /tmp#lin-va-llama1
```

## Install NixOS

```bash
# Install
sudo nixos-install --flake /tmp#lin-va-llama1

# Reboot
sudo reboot
```

## Copy Config to Host

```bash
scp -r * nixos@10.10.10.10:/etc/nixos
```

## Rebuild NixOS

```bash
sudo nixos-rebuild switch
```

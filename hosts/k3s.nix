{ config, pkgs, ... }:

{
  # Enable Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # System Configuration
  boot.kernelModules = [ "nvme_tcp" ]; # OpenEBS Mayastor Requirement
  boot.kernel.sysctl = {
    "vm.nr_hugepages" = 1024;
  };
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";

  # Disk Configuration
  disko.devices = {
    disk = {
      sda = {
        type = "disk";
        device = "/dev/sda";
        content = {
          type = "gpt";
          partitions = {
            boot = {
              size = "512M";
              type = "EF00"; # EFI
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            root = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
          };
        };
      };
    };
  };


  # Network Configuration
  networking = {
    networkmanager.enable = true;
    firewall = {
      enable = true;

      # Single Node Required Ports
      allowedTCPPorts = [ 6443 ];

      # Multi Node Required Ports
      # allowedTCPPorts = [ 6443 2379 2380 10250 ];
      # allowedUDPPorts = [ 8472 ];
    };
  };

  # Enable K3s
  services.k3s = {
    enable = true;
    role = "server";
    extraFlags = toString [
      "--disable=traefik" # Should we enable?
      "--disable=servicelb"
    ];
  };

  # Enable SSH Server
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false; # Disable Password Login
      PermitRootLogin = "prohibit-password"; # Disable Password Login
    };
  };

  # User Configuration
  users.users.root = {
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEA8P84lWL/p13ZBFNwITm/dLWWL8s9pVmdOImM5gaJAiTLY+DheUvG6YsveB2/5STseiJ34g7Na9TW1mtTLL8zDqPvj3NbprQiYlLJKMbCk6dtfdD4nLMHl8B48e1h699XiZDp2/c+jJb0MkLOFrps+FbPqt7pFt1Pj29tFy8BCg0LGndu6KO+HqYS+aM5tp5hZESo1RReiJ8aHsu5X7wW46brN4gfyyu+8X4etSZAB9raWqlln9NKK7G6as6X+uPypvSjYGSTC8TSePV1iTPwOxPk2+1xBsK7EBLg3jNrrYaiXLnZvBOOhm11JmHzqEJ6386FfQO+0r4iDVxmvi+ojw== rsa-key-20141114"
    ];
    hashedPassword = null; # Disable Password Login
  };

  # System Packages
  environment.systemPackages = with pkgs; [
    k9s
    kubectl
    kubernetes-helm
    nfs-utils
    vim
  ];

  # Enable Container Features
  virtualisation = {
    docker.enable = false;
    containerd = {
      enable = true;
      settings = {
        version = 2;
        plugins."io.containerd.grpc.v1.cri" = {
          containerd.runtimes.runc = {
            runtime_type = "io.containerd.runc.v2";
          };
        };
      };
    };
  };

  # System State Version
  system.stateVersion = "24.11";
}

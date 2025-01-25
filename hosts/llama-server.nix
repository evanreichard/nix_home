{ config, pkgs, ... }:

let
  cuda-llama = (pkgs.llama-cpp.override {
    cudaSupport = true;
  }).overrideAttrs (oldAttrs: {
    cmakeFlags = oldAttrs.cmakeFlags ++ [
      "-DGGML_CUDA_ENABLE_UNIFIED_MEMORY=ON"

      # Disable CPU Instructions - Intel(R) Core(TM) i5-3570K CPU @ 3.40GHz
      "-DLLAMA_FMA=OFF"
      "-DLLAMA_AVX2=OFF"
      "-DLLAMA_AVX512=OFF"
      "-DGGML_FMA=OFF"
      "-DGGML_AVX2=OFF"
      "-DGGML_AVX512=OFF"
    ];
  });

  # Define Model Vars
  modelDir = "/models";
  modelName = "qwen2.5-coder-7b-q8_0.gguf";
  modelPath = "${modelDir}/${modelName}";
  modelUrl = "https://huggingface.co/ggml-org/Qwen2.5-Coder-7B-Q8_0-GGUF/resolve/main/${modelName}?download=true";
in

{
  # Enable Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # System Configuration
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";

  # Allow Nvidia & CUDA
  nixpkgs.config.allowUnfree = true;

  # Enable Graphics
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = [ pkgs.cudatoolkit ];
  };

  # Load Nvidia Driver Module
  services.xserver.videoDrivers = [ "nvidia" ];

  # Nvidia Package Configuration
  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    modesetting.enable = true;
    powerManagement.enable = true;
    open = false;
    nvidiaSettings = true;
  };

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
  networking.networkmanager.enable = true;

  # Download Model
  systemd.services.download-model = {
    description = "Download Model";
    wantedBy = [ "multi-user.target" ];
    before = [ "llama-cpp.service" ];
    path = [ pkgs.curl pkgs.coreutils ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      User = "root";
      Group = "root";
    };
    script = ''
      set -euo pipefail

      if [ ! -f "${modelPath}" ]; then
        mkdir -p "${modelDir}"
        # Add -f flag to follow redirects and -L for location
        # Add --fail flag to exit with error on HTTP errors
        # Add -C - to resume interrupted downloads
        curl -f -L -C - \
          -H "Accept: application/octet-stream" \
          --retry 3 \
          --retry-delay 5 \
          --max-time 1800 \
          "${modelUrl}" \
          -o "${modelPath}.tmp" && \
        mv "${modelPath}.tmp" "${modelPath}"
      fi
    '';
  };


  # Setup LLama API Service
  systemd.services.llama-cpp = {
    after = [ "download-model.service" ];
    requires = [ "download-model.service" ];
  };

  # Enable LLama API
  services.llama-cpp = {
    enable = true;
    host = "0.0.0.0";
    package = cuda-llama;
    model = modelPath;
    port = 8080;
    openFirewall = true;
    extraFlags = [
      "-ngl"
      "99"
      "-fa"
      "-ub"
      "512"
      "-b"
      "512"
      "-dt"
      "0.1"
      "--ctx-size"
      "4096"
      "--cache-reuse"
      "256"
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
    htop
    nvtop
    tmux
    vim
    wget
  ];

  # System State Version
  system.stateVersion = "24.11";
}

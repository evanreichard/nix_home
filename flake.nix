{
  description = "NixOS Hosts";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    disko.url = "github:nix-community/disko";
  };

  outputs = { self, nixpkgs, disko }: {
    nixosConfigurations.lin-va-llama1 = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        disko.nixosModules.disko
        ./hosts/llama-server.nix
        {
          networking.hostName = "lin-va-llama1";
        }
      ];
    };

    nixosConfigurations.lin-va-k3s1 = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        disko.nixosModules.disko
        ./hosts/k3s.nix
        {
          networking.hostName = "lin-va-k3s1";
        }
      ];
    };
  };
}

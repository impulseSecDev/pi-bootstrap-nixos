{
  description = "Raspberry-pi-3 bootstrap NixOS configuration";

  # Build image
  # nix build .#nixosConfigurations.pi.config.system.build.sdImage

  # Flash Image 
  # sudo dd if=result/sd-image/nixos-image-sd-card-26.05.20260807.ee48b14-aarch64-linux.img         of=/dev/sdb         bs=4M         status=progress         conv=fsync

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixos-hardware = {
      url = "github:nixos/nixos-hardware";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, nixos-hardware, ... }: {
    nixosConfigurations.pi = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      modules = [
        ./configuration.nix
        nixos-hardware.nixosModules.raspberry-pi-3
        "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
        {
          hardware.raspberry-pi.firmware.uboot.enable = true;
        }
        ({ pkgs, lib, ... }: {
          sdImage.compressImage = false;
        })
      ];
    };
  };
}

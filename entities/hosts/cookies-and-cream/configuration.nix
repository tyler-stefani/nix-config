{ ... }: {
  lab.traits.attributes.cookies-and-cream.nixos =
    {
      self,
      pkgs,
      lib,
      modulesPath,
      ...
    }:
    {
      imports = [
        (modulesPath + "/profiles/qemu-guest.nix")
        self.diskoConfigurations.cookies-and-cream
      ];

      boot.loader.grub.enable = true;

      boot.initrd.availableKernelModules = [
        "ata_piix"
        "uhci_hcd"
        "virtio_pci"
        "sr_mod"
        "virtio_blk"
      ];
      boot.kernelModules = [ "kvm-intel" ];

      networking = {
        hostName = "cookies-and-cream";
        firewall.enable = true;
      };

      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

      environment.systemPackages = with pkgs; [
        git
      ];

      system.stateVersion = "24.11";
    };
}

{ ... }: {
  lab.traits.attributes.bubblegum.nixos =
    {
      pkgs,
      self,
      lib,
      config,
      modulesPath,
      ...
    }:
    {
      imports = [
        (modulesPath + "/installer/scan/not-detected.nix")
        self.diskoConfigurations.bubblegum
      ];

      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;
      boot.kernelPackages = pkgs.linuxPackages_6_1;

      boot.initrd.availableKernelModules = [
        "xhci_pci"
        "ahci"
        "usbhid"
        "usb_storage"
        "sd_mod"
      ];

      networking = {
        hostName = "bubblegum";
        networkmanager.enable = true;
      };

      nixpkgs.config.allowUnfree = true;
      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

      nix.settings = {
        experimental-features = "nix-command flakes pipe-operators";
      };

      hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

      services.avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
      };

      sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

      environment.systemPackages = with pkgs; [
        git
      ];
      system.stateVersion = "25.05";
    };
}

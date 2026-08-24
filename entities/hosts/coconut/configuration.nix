{ ... }: {
  lab.traits.attributes.coconut.nixos =
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
        self.diskoConfigurations.coconut
      ];

      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;
      boot.kernelPackages = pkgs.linuxPackages_6_1;

      boot.initrd.availableKernelModules = [
        "xhci_pci"
        "ahci"
        "nvme"
        "usbhid"
        "usb_storage"
        "sd_mod"
        "fuse"
      ];
      boot.kernelModules = [ "kvm-intel" ];

      fileSystems."/home" = {
        fsType = "mergerfs";
        device = "/mnt/merge/*";
        depends = [
          "/mnt/merge/01"
          "/mnt/merge/02"
        ];
        options = [
          "allow_other"
          "use_ino"
          "cache.files=partial"
          "dropcacheonclose=true"
          "category.create=mfs"
        ];
        noCheck = true;
      };

      networking = {
        hostName = "coconut";
        networkmanager.enable = true;
        firewall.allowedTCPPorts = [ 3000 ];
      };

      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

      hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

      programs.fuse.userAllowOther = true;
      programs.ssh.startAgent = true;

      virtualisation.docker-swarm.enable-manager = true;

      sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

      environment.systemPackages = with pkgs; [
        git
        mergerfs
        mergerfs-tools
      ];

      system.stateVersion = "24.11";
    };
}

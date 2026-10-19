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
          "/mnt/merge/03"
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

      services.snapraid = {
        enable = true;
        dataDisks = {
          d1 = "/mnt/merge/01";
          d2 = "/mnt/merge/02";
          d3 = "/mnt/merge/03";
        };
        parityFiles = [ "/mnt/parity/snapraid.parity" ];
        contentFiles = [
          "/mnt/parity/snapraid.content"
          "/mnt/merge/01/snapraid.content"
          "/mnt/merge/02/snapraid.content"
          "/mnt/merge/03/snapraid.content"
        ];
        sync.interval = "*-*-* 04/12:00:00";
        scrub.interval = "Mon *-*-* 04:00:00";
      };

      environment.systemPackages = with pkgs; [
        git
        mergerfs
        mergerfs-tools
      ];

      system.stateVersion = "24.11";
    };
}

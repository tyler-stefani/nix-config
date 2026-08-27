{ ... }: {
  lab.traits.attributes.bloob.nixos =
    {
      traits,
      pkgs,
      config,
      lib,
      modulesPath,
      ...
    }:
    {
      imports = [
        (modulesPath + "/installer/scan/not-detected.nix")
      ];

      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

      boot.initrd.availableKernelModules = [
        "vmd"
        "xhci_pci"
        "ahci"
        "nvme"
        "usbhid"
        "usb_storage"
        "sd_mod"
      ];
      boot.kernelModules = [ "kvm-intel" ];

      fileSystems."/" = {
        device = "/dev/disk/by-uuid/747a9150-9bea-4530-9810-18b56675e50e";
        fsType = "ext4";
      };

      fileSystems."/boot" = {
        device = "/dev/disk/by-uuid/18D3-E8A1";
        fsType = "vfat";
        options = [
          "fmask=0077"
          "dmask=0077"
        ];
      };

      networking = {
        hostName = "bloob";
        networkmanager.enable = true;
      };

      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

      hardware.cpu.intel.updateMicrocode =
        lib.mkDefault config.hardware.enableRedistributableFirmware;

      hardware.graphics = {
        enable = true;
        enable32Bit = true;
      };

      hardware.nvidia = {
        modesetting.enable = true;
        open = false;
        nvidiaSettings = true;
        # required for GTX 1060 (Pascal)
        package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
        powerManagement.enable = true;
      };

      services.printing.enable = true;

      services.xserver.videoDrivers = [ "nvidia" ];

      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
      };

      systemd.tmpfiles.settings.cosmic-greeter = {
        "/var/lib/cosmic-greeter/.local/state/cosmic-comp".d = {
          mode = "0700";
          user = "cosmic-greeter";
          group = "cosmic-greeter";
        };
        "/var/lib/cosmic-greeter/.local/state/cosmic-comp/outputs.ron".C = {
          type = "C+";
          mode = "0644";
          user = "cosmic-greeter";
          group = "cosmic-greeter";
          argument = "${pkgs.writeText "cosmic-comp-outputs.ron" (
            builtins.readFile ./cosmic-comp-outputs.ron
          )}";
        };
      };

      sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

      environment.systemPackages = with pkgs; [
        wget
      ];

      system.stateVersion = "25.11";
    };
}

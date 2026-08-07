{
  traits,
  pkgs,
  config,
  ...
}:
{
  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "bloob";
  networking.networkmanager.enable = true;

  services.printing.enable = true;

  services.xserver.videoDrivers = [ "nvidia" ];

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

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  environment.systemPackages = with pkgs; [
    wget
  ];

  system.stateVersion = "25.11";
}

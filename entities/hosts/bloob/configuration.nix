{ traits, pkgs, ... }:
{
  imports = with traits; [
    ./hardware-configuration.nix

    is.nixos
    is.ssh-server

    has.user-tyler
    has.desktop-environment
    has.games
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "bloob";
  networking.networkmanager.enable = true;

  services.printing.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
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

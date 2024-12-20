# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:
let
  unstableTarball =
    fetchTarball
      https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz;

in
{
  imports =
    [ # Include the results of the hardware scan.
      <agenix/modules/age.nix>
      ./hardware-configuration.nix
      ../common/richardsl.nix
      ../common/openssh.nix
      ../common/virtualization.nix
      ../common/traefik.nix
      ../common/acme.nix
      ../common/cockpit.nix
      ../common/erigon-ethereum-holesky.nix
      ../common/opstack-garnet.nix
      ../common/prometheus.nix
      ../common/grafana.nix
      ../common/frontier-collector.nix
      (fetchTarball "https://github.com/nix-community/nixos-vscode-server/tarball/master")
    ];

  age.secrets.user_hashed_password.file = ../secrets/user_hashed_password.age;
  age.identityPaths = [ "/home/richardsl/.ssh/id_ed25519" ];

  nixpkgs.config = {
    packageOverrides = pkgs: with pkgs; {
      unstable = import unstableTarball {
        config = config.nixpkgs.config;
      };
    };
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "BRIX0001";
  networking.networkmanager.enable = true;

  time.timeZone = "UTC";

  i18n.defaultLocale = "en_US.UTF-8";

  services.xserver.enable = false;
  hardware.pulseaudio.enable = false;
  services.libinput.enable = false;

  services.logind.extraConfig = ''
    # don’t shutdown when power button is short-pressed
    HandlePowerKey=ignore
  '';

  virtualisation.podman.enable = true;

  environment.systemPackages = with pkgs; [
    pkgs.unstable.neovim
    pkgs.unstable.oh-my-posh
    pkgs.wget
    pkgs.bat
    pkgs.zsh
    pkgs.htop
    pkgs.tmux
    pkgs.fzf
    pkgs.zsh-syntax-highlighting
    pkgs.zsh-autosuggestions
    pkgs.unzip
    pkgs.gnupg
    pkgs.lsb-release
    pkgs.gitMinimal
    pkgs.gcc
    pkgs.gnumake
    pkgs.yarn
    pkgs.prometheus-node-exporter
  ];

  system.copySystemConfiguration = true;
  system.autoUpgrade = {
    enable = true;
    allowReboot = true;
    flags = [
      "-I" "nixos-config=/home/richardsl/nixos/src/brix0001/configuration.nix"
    ];
  };

  networking.nat = {
    enable = true;
    internalInterfaces = ["ve-+"];
    externalInterface = "enp0s31f6";
    enableIPv6 = false;
  };

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?
}

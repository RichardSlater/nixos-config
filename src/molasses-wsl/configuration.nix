# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{
  config,
  lib,
  pkgs,
  ...
}:
let
  unstableTarball = fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";

in
{
  imports = [
    # include NixOS-WSL modules
    <nixos-wsl/modules>
    ./hardware-configuration.nix
    ../common/richardsl.nix
    ../common/virtualization.nix
    ../common/traefik.nix
    ../common/acme.nix

    <agenix/modules/age.nix>
    (fetchTarball "https://github.com/nix-community/nixos-vscode-server/tarball/master")
  ];

  networking.hostName = "molasses";

  services.vscode-server.enable = true;

  nixpkgs.config = {
    packageOverrides =
      pkgs: with pkgs; {
        unstable = import unstableTarball { config = config.nixpkgs.config; };
      };
  };

  i18n.defaultLocale = "en_US.UTF-8";

  services.xserver.enable = false;
  hardware.pulseaudio.enable = false;
  services.libinput.enable = false;

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    glibc
    gcc.cc.lib
  ];

  environment.systemPackages = with pkgs; [
    (pkgs.callPackage <agenix/pkgs/agenix.nix> { })
    pkgs.unstable.neovim
    pkgs.unstable.oh-my-posh
    pkgs.wget
    pkgs.bat
    pkgs.zsh
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
    pkgs.dig
    pkgs.unstable.nixfmt-rfc-style
  ];

  system.copySystemConfiguration = true;
  system.autoUpgrade.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}

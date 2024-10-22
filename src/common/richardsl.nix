{ config, pkgs, ... }:

{
  age.secrets.user_hashed_password.file = ../secrets/user_hashed_password.age;
  age.identityPaths = [ "/home/richardsl/.ssh/id_ed25519" ];

  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
  };

  users.users.richardsl = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ];
    packages = with pkgs; [
      pkgs.unstable.chezmoi
    ];
    shell = pkgs.zsh;
    hashedPasswordFile = config.age.secrets.user_hashed_password.path;
  };
}

{ config, lib, pkgs, ... }:

let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz";
in
{

  imports = [
    ./hardware-configuration.nix
    ./modules/boot.nix
    ./modules/networking.nix
    ./modules/users.nix
    ./modules/packages.nix
    ./modules/services.nix
    ./modules/power.nix
    ./modules/virtualization.nix
    ./modules/maintenance.nix
    ./modules/fonts.nix  # <-- Add this line for fonts module
    (import "${home-manager}/nixos")
  ];

  # Home Manager configuration
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    backupFileExtension = "backup";
    users.haschwalth = import ./home.nix;
  };

  #flakes setup
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Localization
  time.timeZone = "Asia/Kolkata";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # System state version (DO NOT CHANGE)
  system.stateVersion = "24.11";

  # ZSH
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    ohMyZsh = {
      enable = true;
      plugins = [ "git" "sudo" "docker" ];
    };

    promptInit = ''
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
    '';
  };


}


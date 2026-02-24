{ config, lib, pkgs, ... }:
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
    ./modules/fonts.nix
  ];

  # ── Home Manager ───────────────────────────────────────────────────────────
  home-manager = {
    useUserPackages     = true;
    useGlobalPkgs       = true;
    backupFileExtension = "backup";
    users.haschwalth    = import ./home.nix;
  };

  # ── Nix / Flakes ──────────────────────────────────────────────────────────
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # ── Localization ──────────────────────────────────────────────────────────
  time.timeZone = "Asia/Kolkata";

  # ── Unfree packages ────────────────────────────────────────────────────────
  nixpkgs.config.allowUnfree = true;

  # ── ZSH (system-wide) ─────────────────────────────────────────────────────
  programs.zsh = {
    enable                    = true;
    enableCompletion          = true;
    autosuggestions.enable    = true;
    syntaxHighlighting.enable = true;
    ohMyZsh = {
      enable  = true;
      plugins = [ "git" "sudo" "docker" ];
    };
    promptInit = ''
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
    '';
  };

  # ── System state version (DO NOT CHANGE) ──────────────────────────────────
  system.stateVersion = "24.11";
}

